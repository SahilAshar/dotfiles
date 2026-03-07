#!/usr/bin/env bash
set -euo pipefail

# Dotfiles installer - optimized for GitHub Codespaces
# Safe to run multiple times (idempotent)
# Automatically invoked by Codespaces on container creation

# Determine script directory
# In Codespaces: /workspaces/.codespaces/.persistedshare/dotfiles
# Locally: wherever user cloned the repo
if [ -n "${CODESPACES:-}" ]; then
  SCRIPT_DIR="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

DOTFILES_DIR="${DOTFILES_DIR:-$SCRIPT_DIR}"
APT_PACKAGES_FILE="${APT_PACKAGES_FILE:-$DOTFILES_DIR/apt-packages.txt}"

echo "=============================="
echo "Dotfiles Installation"
echo "=============================="
echo "Script dir: $SCRIPT_DIR"
echo "Dotfiles dir: $DOTFILES_DIR"
if [ -n "${CODESPACES:-}" ]; then echo "Environment: Codespaces"; else echo "Environment: Local"; fi
echo ""

run_as_root() {
  if command -v sudo >/dev/null 2>&1 && [ "$EUID" -ne 0 ]; then
    sudo "$@"
  else
    "$@"
  fi
}

disable_broken_yarn_apt_source() {
  local source_file

  for source_file in /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources; do
    [ -f "$source_file" ] || continue

    if grep -qi "dl.yarnpkg.com" "$source_file"; then
      local disabled_file="${source_file}.disabled-by-dotfiles"

      # Idempotent: if we've already disabled it, don't do it again.
      if [ -f "$disabled_file" ]; then
        continue
      fi

      run_as_root mv "$source_file" "$disabled_file"

      echo "→ Disabled broken yarn apt source: $source_file"
    fi
  done
}

# Install apt packages (Linux/Codespaces only)
install_apt_packages() {
  # Skip if no package file
  if [ ! -f "$APT_PACKAGES_FILE" ]; then
    echo "→ No apt packages file found; skipping"
    return
  fi

  # Skip if apt-get unavailable (macOS default)
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "→ apt-get not available; skipping package install (likely macOS)"
    return
  fi

  # Read packages, skip comments/blank lines
  mapfile -t apt_packages < <(sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$APT_PACKAGES_FILE")

  if [ "${#apt_packages[@]}" -eq 0 ]; then
    echo "→ No packages listed in $APT_PACKAGES_FILE"
    return
  fi

  # Check which packages are missing
  local missing_packages=()
  for package in "${apt_packages[@]}"; do
    if ! dpkg -s "$package" >/dev/null 2>&1; then
      missing_packages+=("$package")
    fi
  done

  if [ "${#missing_packages[@]}" -eq 0 ]; then
    echo "✓ All apt packages already installed"
    return
  fi

  echo "→ Installing apt packages: ${missing_packages[*]}"

  local apt_update_output
  if ! apt_update_output="$(run_as_root apt-get update -qq 2>&1)"; then
    echo "$apt_update_output" >&2

    # Best-effort repair for a known transient issue in some universal image variants.
    if echo "$apt_update_output" | grep -q "dl.yarnpkg.com"; then
      echo "⚠ Detected broken yarn apt source in base image; disabling it and retrying apt-get update"
      disable_broken_yarn_apt_source || true
      local retry_apt_update_output
      if ! retry_apt_update_output="$(run_as_root apt-get update -qq 2>&1)"; then
        echo "$retry_apt_update_output" >&2
        echo "✗ ERROR: apt-get update failed after disabling broken yarn apt source" >&2
        exit 1
      fi
    else
      echo "✗ ERROR: apt-get update failed" >&2
      exit 1
    fi
  fi

  run_as_root apt-get install -y -qq "${missing_packages[@]}"

  echo "✓ Packages installed"
}

# Install Oh My Zsh (if missing)
install_ohmyzsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✓ Oh My Zsh already installed"
    return
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "✗ ERROR: curl is required to install Oh My Zsh" >&2
    exit 1
  fi

  echo "→ Installing Oh My Zsh..."

  # Don't start new shell, don't overwrite existing .zshrc
  export RUNZSH=no
  export KEEP_ZSHRC=yes

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
    echo "✗ Oh My Zsh installation failed" >&2
    exit 1
  }

  echo "✓ Oh My Zsh installed"
}

# Install Powerlevel10k theme (if missing)
install_powerlevel10k() {
  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  local theme_dir="$zsh_custom/themes/powerlevel10k"

  if [ -d "$theme_dir" ]; then
    echo "✓ Powerlevel10k already installed"
    return
  fi

  if ! command -v git >/dev/null 2>&1; then
    echo "✗ ERROR: git is required to install Powerlevel10k" >&2
    exit 1
  fi

  echo "→ Installing Powerlevel10k theme..."
  mkdir -p "$zsh_custom/themes"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir" || {
    echo "✗ Powerlevel10k installation failed" >&2
    exit 1
  }

  echo "✓ Powerlevel10k installed"
}

# Install zsh-autosuggestions plugin (if missing)
install_zsh_autosuggestions() {
  local plugin_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"

  if [ -d "$plugin_dir" ]; then
    echo "✓ zsh-autosuggestions already installed"
    return
  fi

  if ! command -v git >/dev/null 2>&1; then
    echo "✗ ERROR: git is required to install zsh-autosuggestions" >&2
    exit 1
  fi

  echo "→ Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$plugin_dir" || {
    echo "✗ zsh-autosuggestions installation failed" >&2
    exit 1
  }

  echo "✓ zsh-autosuggestions installed"
}

# Link dotfiles into home directory
# Args: relative_source_path target_filename
link_file() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME/$2"

  if [ ! -e "$src" ]; then
    echo "✗ ERROR: Source file does not exist: $src" >&2
    exit 1
  fi

  # If source and destination resolve to the same file, skip (e.g. ~/.claude -> ~/dotfiles/.claude)
  if [ "$(readlink -f "$src")" = "$(readlink -f "$dest")" ] 2>/dev/null; then
    echo "✓ Already in place (same path): $dest"
    return
  fi

  # If symlink already points to correct location, skip
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "✓ Symlink already correct: $dest"
    return
  fi

  # Backup existing file/symlink if present
  if [ -L "$dest" ] || [ -e "$dest" ]; then
    local backup="$dest.bak"
    if [ -e "$backup" ]; then
      echo "✗ ERROR: Backup already exists: $backup" >&2
      echo "  Resolve manually before re-running." >&2
      exit 1
    fi
    echo "→ Backing up existing file: $dest → $backup"
    mv "$dest" "$backup"
  fi

  # Create parent directory if needed
  mkdir -p "$(dirname "$dest")"

  # Create symlink
  ln -s "$src" "$dest"
  echo "✓ Linked: $dest → $src"
}

# Merge dotfiles VS Code settings into the machine settings file
deploy_vscode_settings() {
  local src="$DOTFILES_DIR/vscode/settings.json"
  local vscode_remote_dest="$HOME/.vscode-remote/data/Machine/settings.json"
  local vscode_server_dest="$HOME/.vscode-server/data/Machine/settings.json"

  if [ ! -f "$src" ]; then
    echo "→ No vscode/settings.json found; skipping"
    return
  fi

  if ! command -v jq >/dev/null 2>&1; then
    echo "⚠ Warning: jq not available; skipping VS Code settings merge" >&2
    return
  fi

  # Merge into both .vscode-remote and .vscode-server to ensure consistency across environments
  for dest in "$vscode_remote_dest" "$vscode_server_dest"; do
    mkdir -p "$(dirname "$dest")"
    if [ -f "$dest" ]; then
      local merged
      merged=$(jq -s '.[0] * .[1]' "$dest" "$src")
      echo "$merged" > "$dest"
      echo "✓ Merged VS Code settings into $dest"
    else
      cp "$src" "$dest"
      echo "✓ Wrote VS Code settings to $dest"
    fi
  done
}

# Deploy Claude Code settings, respecting CLAUDE_CONFIG_DIR if set
deploy_claude_settings() {
  # Determine target directory: CLAUDE_CONFIG_DIR if set, otherwise ~/.claude
  local claude_config_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
  mkdir -p "$claude_config_dir"

  # Merge settings.json if present
  local src="$DOTFILES_DIR/.claude/settings.json"
  if [ -f "$src" ]; then
    local dest="$claude_config_dir/settings.json"
    if ! command -v jq >/dev/null 2>&1; then
      echo "⚠ Warning: jq not available; skipping Claude settings merge" >&2
    elif [ -f "$dest" ]; then
      local merged
      merged=$(jq -s '.[0] * .[1]' "$dest" "$src")
      echo "$merged" > "$dest"
      echo "✓ Merged Claude settings into $dest"
    else
      cp "$src" "$dest"
      echo "✓ Wrote Claude settings to $dest"
    fi
  else
    echo "→ No .claude/settings.json found; skipping settings merge"
  fi

  # Deploy statusline script if present
  local statusline_src="$DOTFILES_DIR/.claude/statusline-command.sh"
  if [ -f "$statusline_src" ]; then
    cp "$statusline_src" "$claude_config_dir/statusline-command.sh"
    chmod +x "$claude_config_dir/statusline-command.sh"
    echo "✓ Deployed Claude statusline script to $claude_config_dir/statusline-command.sh"
  fi
}

# Install Claude Code (Codespaces only)
install_claude_code() {
  if [ -z "${CODESPACES:-}" ]; then
    echo "→ Not in Codespaces; skipping Claude Code install"
    return
  fi

  if command -v claude >/dev/null 2>&1; then
    echo "✓ Claude Code already installed ($(claude --version 2>/dev/null || echo 'unknown version'))"
    return
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "✗ ERROR: curl is required to install Claude Code" >&2
    exit 1
  fi

  echo "→ Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash || {
    echo "✗ Claude Code installation failed" >&2
    exit 1
  }

  echo "✓ Claude Code installed"
}

# Main installation flow
main() {
  echo "Starting installation..."
  echo ""

  install_apt_packages
  echo ""

  install_ohmyzsh
  echo ""

  install_powerlevel10k
  echo ""

  install_zsh_autosuggestions
  echo ""

  echo "→ Linking shell configuration files..."
  link_file "zsh/.zshrc" ".zshrc"

  if [ -f "$DOTFILES_DIR/zsh/.p10k.zsh" ]; then
    link_file "zsh/.p10k.zsh" ".p10k.zsh"
  fi

  if [ -f "$DOTFILES_DIR/git/.gitconfig" ]; then
    link_file "git/.gitconfig" ".gitconfig"
  fi

  if [ -f "$DOTFILES_DIR/ghostty/config" ]; then
    link_file "ghostty/config" ".config/ghostty/config"
  fi

  deploy_claude_settings

  if [ -d "$DOTFILES_DIR/.claude/skills" ]; then
    echo "→ Linking Claude Code skills..."
    local claude_skills_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills"
    mkdir -p "$claude_skills_dir"
    for skill_dir in "$DOTFILES_DIR/.claude/skills"/*/; do
      [ -d "$skill_dir" ] || continue
      local skill_name
      skill_name="$(basename "$skill_dir")"
      if [ ! -f "$skill_dir/SKILL.md" ]; then
        echo "⚠ Skipping skill '$skill_name': SKILL.md not found" >&2
        continue
      fi
      local dest="$claude_skills_dir/$skill_name"
      if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$skill_dir" ]; then
        echo "✓ Skill symlink already correct: $skill_name"
      else
        if [ -L "$dest" ] || [ -e "$dest" ]; then
          echo "→ Replacing existing skill: $skill_name"
          rm -rf "$dest"
        fi
        ln -s "$skill_dir" "$dest"
        echo "✓ Linked skill: $skill_name → $skill_dir"
      fi
    done
  fi

  echo ""

  install_claude_code
  echo ""

  echo "→ Deploying VS Code settings..."
  deploy_vscode_settings
  echo ""

  echo "=============================="
  echo "✓ Installation complete!"
  echo "=============================="

  if [ -z "${CODESPACES:-}" ]; then
    echo ""
    echo "Next steps:"
    echo "  1. Reload your terminal: exec zsh"
    echo "  2. Configure your GitHub Codespaces settings to use this repo"
  fi
}

# Run installation
main
