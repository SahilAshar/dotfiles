#!/usr/bin/env bash
set -euo pipefail

#!/usr/bin/env bash
set -euo pipefail

# Directory where this script resides (i.e., the repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$SCRIPT_DIR}"

echo "PWD: $(pwd)"
echo "Using dotfiles dir: $DOTFILES_DIR"

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

link_file() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME/$2"

  if [ ! -e "$src" ]; then
    echo "Source $src does not exist"
    exit 1
  fi

  if [ -L "$dest" ]; then
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

install_ohmyzsh

# Install custom plugins
install_autocomplete

link_file "zsh/.zshrc" ".zshrc"

echo "Done. Open a new terminal or run: exec zsh"
