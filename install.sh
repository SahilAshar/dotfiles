#!/usr/bin/env bash
set -euo pipefail

#!/usr/bin/env bash
set -euo pipefail

# Directory where this script resides (i.e., the repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$SCRIPT_DIR}"
APT_PACKAGES_FILE="${APT_PACKAGES_FILE:-$DOTFILES_DIR/apt-packages.txt}"

echo "PWD: $(pwd)"
echo "Using dotfiles dir: $DOTFILES_DIR"
echo "Bootstrap mode: re-checking installs"

install_apt_packages() {
  if [ ! -f "$APT_PACKAGES_FILE" ]; then
    echo "No apt package file at $APT_PACKAGES_FILE; skipping apt installs."
    return
  fi

  if ! command -v apt-get >/dev/null 2>&1; then
    echo "apt-get not available; skipping apt installs."
    return
  fi

  mapfile -t apt_packages < <(sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e '/^$/d' "$APT_PACKAGES_FILE")
  if [ "${#apt_packages[@]}" -eq 0 ]; then
    echo "No apt packages listed in $APT_PACKAGES_FILE; skipping apt installs."
    return
  fi

  local missing_packages=()
  for package in "${apt_packages[@]}"; do
    if ! dpkg -s "$package" >/dev/null 2>&1; then
      missing_packages+=("$package")
    fi
  done

  if [ "${#missing_packages[@]}" -eq 0 ]; then
    echo "Apt packages already installed."
    return
  fi

  echo "Installing apt packages: ${missing_packages[*]}"

  if command -v sudo >/dev/null 2>&1 && [ "$EUID" -ne 0 ]; then
    sudo apt-get update
    sudo apt-get install -y "${missing_packages[@]}"
  else
    apt-get update
    apt-get install -y "${missing_packages[@]}"
  fi
}

install_ohmyzsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh already installed at $HOME/.oh-my-zsh"
    return
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "Error: curl is required to install Oh My Zsh."
    exit 1
  fi

  echo "Installing Oh My Zsh..."
  # Don't auto-start a new shell, and don't overwrite any existing .zshrc
  export RUNZSH=no
  export KEEP_ZSHRC=yes

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_autocomplete() {
  if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions already installed."
    return
  fi

  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
}

install_powerlevel10k() {
  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  local theme_dir="$zsh_custom/themes/powerlevel10k"

  if [ -d "$theme_dir" ]; then
    echo "Powerlevel10k already installed at $theme_dir"
    return
  fi

  if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is required to install Powerlevel10k."
    exit 1
  fi

  echo "Installing Powerlevel10k theme into $theme_dir..."
  mkdir -p "$zsh_custom/themes"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir"
}

link_file() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME/$2"

  if [ ! -e "$src" ]; then
    echo "Source $src does not exist"
    exit 1
  fi

  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$src" ]; then
      echo "Symlink already set for $dest -> $src"
      return
    fi
    # existing symlink -> replace
    rm "$dest"
  elif [ -e "$dest" ]; then
    echo "Backing up existing $dest to $dest.bak"
    mv "$dest" "$dest.bak"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "Linked $dest -> $src"
}

install_apt_packages

install_ohmyzsh

# Install Powerlevel10k theme
install_powerlevel10k

# Install custom plugins
install_autocomplete

link_file "zsh/.zshrc" ".zshrc"

if [ -f "$DOTFILES_DIR/zsh/.p10k.zsh" ]; then
  link_file "zsh/.p10k.zsh" ".p10k.zsh"
fi

echo "Syncing Copilot prompts (run ./install.sh; scripts/install-prompts.sh is internal)"
"$DOTFILES_DIR/scripts/install-prompts.sh"

echo "Done. Open a new terminal or run: exec zsh"
