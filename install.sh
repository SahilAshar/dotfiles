#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

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
link_file "zsh/.zshrc" ".zshrc"

echo "Done. Open a new terminal or run: exec zsh"
