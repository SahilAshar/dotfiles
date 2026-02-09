#!/usr/bin/env bash
set -euo pipefail

# Test suite for install.sh
# Tests the installer against its design philosophy:
#   - Idempotent (safe to run multiple times)
#   - Codespaces-first (correct environment detection)
#   - No user interaction (unattended execution)
#   - Cross-platform (graceful skips on macOS)
#
# Uses static analysis + isolated behavioral tests to avoid
# modifying the real environment. Compatible with macOS bash 3.2+.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL_SH="$REPO_ROOT/install.sh"

PASS=0
FAIL=0
ERRORS=()

# ── Helpers ──────────────────────────────────────────────────

pass() {
  PASS=$((PASS + 1))
  echo "  ✓ $1"
}

fail() {
  FAIL=$((FAIL + 1))
  ERRORS+=("$1: $2")
  echo "  ✗ $1"
  echo "    → $2"
}

# ── Tests ────────────────────────────────────────────────────

echo ""
echo "=============================="
echo " install.sh test suite"
echo "=============================="
echo ""

# ── 1. Environment detection ────────────────────────────────

echo "Environment detection"

# Test: Local environment string is exactly "Local"
output=$(CODESPACES="" bash -c "$(grep 'echo.*Environment:' "$INSTALL_SH")" 2>/dev/null)
if [ "$output" = "Environment: Local" ]; then
  pass "Local environment displays 'Local'"
else
  fail "Local environment displays 'Local'" "Got '$output'"
fi

# Test: Codespaces environment string is exactly "Codespaces"
output=$(CODESPACES="true" bash -c "$(grep 'echo.*Environment:' "$INSTALL_SH")" 2>/dev/null)
if [ "$output" = "Environment: Codespaces" ]; then
  pass "Codespaces environment displays 'Codespaces'"
else
  fail "Codespaces environment displays 'Codespaces'" "Got '$output', expected 'Environment: Codespaces'"
fi

echo ""

# ── 2. apt package parsing ──────────────────────────────────

echo "Package file parsing"

# Create a temporary fixture to test parsing logic without coupling to repo contents
FIXTURE_DIR=$(mktemp -d)
trap 'rm -rf "$FIXTURE_DIR"' EXIT
cat > "$FIXTURE_DIR/apt-packages.txt" <<'EOF'
# Core tools
zsh
  ripgrep   

# Commented out
# htop
EOF

# Test: Reads packages correctly (skipping comments and blanks)
packages=$(sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$FIXTURE_DIR/apt-packages.txt")
expected=$'zsh\nripgrep'
if [ "$packages" = "$expected" ]; then
  pass "Parses package file correctly (strips comments, blanks, whitespace)"
else
  fail "Parses package file correctly" "Got '$packages'"
fi

# Test: Array iteration uses values, not count
# Reproduces the for-loop pattern; uses while-read for macOS bash 3.x compat
# printf adds trailing newline to handle files missing one (POSIX read quirk)
iterated=()
while IFS= read -r pkg; do
  [ -n "$pkg" ] && iterated+=("$pkg")
done < <(sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$FIXTURE_DIR/apt-packages.txt" && printf '\n')

if [ "${#iterated[@]}" -eq 2 ] && [ "${iterated[0]}" = "zsh" ] && [ "${iterated[1]}" = "ripgrep" ]; then
  pass "Array iteration yields package names"
else
  fail "Array iteration yields package names" "Got ${iterated[*]:-nothing}"
fi

# Test: install.sh uses correct array expansion in package loop
# ${apt_packages[@]} iterates values; ${#apt_packages[@]} is the count (bug)
loop_line=$(grep 'for package in' "$INSTALL_SH")
# shellcheck disable=SC2016 # Intentional: matching literal ${} in source
if echo "$loop_line" | grep -q '"\${apt_packages\[@\]}"'; then
  pass "Package loop iterates array values (\${apt_packages[@]})"
elif echo "$loop_line" | grep -q '"\${#apt_packages\[@\]}"'; then
  fail "Package loop iterates array values" "Uses \${#apt_packages[@]} (array length) instead of \${apt_packages[@]}"
else
  fail "Package loop iterates array values" "Unexpected pattern: $loop_line"
fi

echo ""

# ── 3. Graceful skips (cross-platform) ──────────────────────

echo "Cross-platform graceful skips"

# Test: Script checks for apt-get before trying to use it
if grep -q 'command -v apt-get' "$INSTALL_SH"; then
  pass "Checks for apt-get availability before use"
else
  fail "Checks for apt-get availability before use" "No apt-get check found"
fi

# Test: Script checks for package file existence
if grep -q '! -f.*APT_PACKAGES_FILE' "$INSTALL_SH"; then
  pass "Checks apt-packages.txt existence before reading"
else
  fail "Checks apt-packages.txt existence before reading" "No file existence check found"
fi

# Test: Script checks for curl before Oh My Zsh install
if grep -q 'command -v curl' "$INSTALL_SH"; then
  pass "Checks for curl before Oh My Zsh install"
else
  fail "Checks for curl before Oh My Zsh install" "No curl check found"
fi

# Test: Script checks for git before clone operations
git_checks=$(grep -c 'command -v git' "$INSTALL_SH")
if [ "$git_checks" -ge 2 ]; then
  pass "Checks for git before clone operations ($git_checks checks)"
else
  fail "Checks for git before clone operations" "Only $git_checks git checks found, expected ≥2"
fi

echo ""

# ── 4. Symlink behavior (link_file) ─────────────────────────

echo "Symlink behavior (link_file)"

SANDBOX="$(mktemp -d)"
FAKE_HOME="$SANDBOX/home"
FAKE_DOTFILES="$SANDBOX/dotfiles"
mkdir -p "$FAKE_HOME" "$FAKE_DOTFILES/zsh"
echo "zsh config" > "$FAKE_DOTFILES/zsh/.zshrc"

# Extract link_file function and test it in isolation
cat > "$SANDBOX/test_link.sh" << 'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail
DOTFILES_DIR="$1"; shift
export HOME="$1"; shift
ACTION="$1"; shift

link_file() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME/$2"
  if [ ! -e "$src" ]; then
    echo "ERROR: Source file does not exist: $src" >&2
    return 1
  fi
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ALREADY_CORRECT"
    return
  fi
  if [ -L "$dest" ] || [ -e "$dest" ]; then
    local backup="$dest.bak"
    if [ -e "$backup" ]; then
      echo "ERROR: Backup already exists: $backup" >&2
      return 1
    fi
    mv "$dest" "$backup"
    echo "BACKED_UP"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "LINKED"
}

case "$ACTION" in
  create)    link_file "zsh/.zshrc" ".zshrc" ;;
  idempotent) link_file "zsh/.zshrc" ".zshrc" ;;
  backup)    echo "original" > "$HOME/.target"; link_file "zsh/.zshrc" ".target" ;;
  backup_exists) echo "original" > "$HOME/.target2"; echo "old" > "$HOME/.target2.bak"; link_file "zsh/.zshrc" ".target2" ;;
  missing)   link_file "nonexistent" ".test" ;;
esac
SCRIPT
chmod +x "$SANDBOX/test_link.sh"

# Test: Creates symlink to correct target
output=$(bash "$SANDBOX/test_link.sh" "$FAKE_DOTFILES" "$FAKE_HOME" create 2>&1)
if [ -L "$FAKE_HOME/.zshrc" ]; then
  target=$(readlink "$FAKE_HOME/.zshrc")
  if [ "$target" = "$FAKE_DOTFILES/zsh/.zshrc" ]; then
    pass "Creates correct symlink (~/.zshrc → zsh/.zshrc)"
  else
    fail "Creates correct symlink" "Points to '$target'"
  fi
else
  fail "Creates correct symlink" "$HOME/.zshrc is not a symlink"
fi

# Test: Idempotent — running again skips
output=$(bash "$SANDBOX/test_link.sh" "$FAKE_DOTFILES" "$FAKE_HOME" idempotent 2>&1)
if echo "$output" | grep -q "ALREADY_CORRECT"; then
  pass "Idempotent: skips when symlink already correct"
else
  fail "Idempotent: skips when symlink already correct" "Got: $output"
fi

# Test: Backs up existing file before replacing
output=$(bash "$SANDBOX/test_link.sh" "$FAKE_DOTFILES" "$FAKE_HOME" backup 2>&1)
if [ -f "$FAKE_HOME/.target.bak" ] && echo "$output" | grep -q "BACKED_UP"; then
  pass "Backs up existing file before symlinking"
else
  fail "Backs up existing file" "No backup created or wrong output: $output"
fi

# Test: Refuses to overwrite existing backup
set +e
output=$(bash "$SANDBOX/test_link.sh" "$FAKE_DOTFILES" "$FAKE_HOME" backup_exists 2>&1)
exit_code=$?
set -e
if [ "$exit_code" -ne 0 ] && echo "$output" | grep -q "Backup already exists"; then
  pass "Refuses to overwrite existing .bak file"
else
  fail "Refuses to overwrite existing .bak file" "exit=$exit_code, output: $output"
fi

# Test: Errors on missing source file
set +e
output=$(bash "$SANDBOX/test_link.sh" "$FAKE_DOTFILES" "$FAKE_HOME" missing 2>&1)
exit_code=$?
set -e
if [ "$exit_code" -ne 0 ] && echo "$output" | grep -q "ERROR.*does not exist"; then
  pass "Errors on missing source file"
else
  fail "Errors on missing source file" "exit=$exit_code, output: $output"
fi

rm -rf "$SANDBOX"

echo ""

# ── 5. Idempotency guards (static analysis) ─────────────────

echo "Idempotency guards"

# Test: Oh My Zsh checks for existing directory
if grep -q '\-d.*oh-my-zsh' "$INSTALL_SH"; then
  pass "Oh My Zsh: checks if already installed before downloading"
else
  fail "Oh My Zsh: checks if already installed" "No directory check found"
fi

# Test: Powerlevel10k checks for existing directory
if grep -q '\-d.*powerlevel10k' "$INSTALL_SH"; then
  pass "Powerlevel10k: checks if already installed before cloning"
else
  fail "Powerlevel10k: checks if already installed" "No directory check found"
fi

# Test: zsh-autosuggestions checks for existing directory (via $plugin_dir variable)
if grep -q '\-d.*plugin_dir' "$INSTALL_SH"; then
  pass "zsh-autosuggestions: checks if already installed before cloning"
else
  fail "zsh-autosuggestions: checks if already installed" "No directory check found"
fi

# Test: link_file checks for existing correct symlink
if grep -q 'readlink.*dest.*=.*src' "$INSTALL_SH"; then
  pass "link_file: checks if symlink already correct"
else
  fail "link_file: checks if symlink already correct" "No readlink comparison found"
fi

# Test: RUNZSH=no prevents Oh My Zsh from launching interactive shell
if grep -q 'RUNZSH=no' "$INSTALL_SH"; then
  pass "Oh My Zsh: RUNZSH=no prevents interactive shell"
else
  fail "Oh My Zsh: RUNZSH=no prevents interactive shell" "Missing RUNZSH=no"
fi

# Test: KEEP_ZSHRC=yes prevents Oh My Zsh from overwriting .zshrc
if grep -q 'KEEP_ZSHRC=yes' "$INSTALL_SH"; then
  pass "Oh My Zsh: KEEP_ZSHRC=yes preserves existing .zshrc"
else
  fail "Oh My Zsh: KEEP_ZSHRC=yes preserves existing .zshrc" "Missing KEEP_ZSHRC=yes"
fi

echo ""

# ── 6. Script safety ────────────────────────────────────────

echo "Script safety"

# Test: Uses strict mode
if head -3 "$INSTALL_SH" | grep -q 'set -euo pipefail'; then
  pass "Uses strict mode (set -euo pipefail)"
else
  fail "Uses strict mode" "Missing set -euo pipefail in header"
fi

# Test: Errors go to stderr
stderr_count=$(grep -c '>&2' "$INSTALL_SH")
if [ "$stderr_count" -ge 3 ]; then
  pass "Error messages written to stderr ($stderr_count instances)"
else
  fail "Error messages written to stderr" "Only $stderr_count instances found"
fi

# Test: deploy_copilot_prompts handles missing script gracefully
if grep -A5 'deploy_copilot_prompts()' "$INSTALL_SH" | grep -q '\-x.*install-prompts'; then
  pass "deploy_copilot_prompts checks script is executable before running"
else
  fail "deploy_copilot_prompts checks script is executable" "No -x check found"
fi

echo ""

# ── Results ──────────────────────────────────────────────────

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="

if [ ${#ERRORS[@]} -gt 0 ]; then
  echo ""
  echo "Failures:"
  for err in "${ERRORS[@]}"; do
    echo "  ✗ $err"
  done
fi

echo ""
exit "$FAIL"
