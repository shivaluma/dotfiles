#!/bin/bash
set -euf -o pipefail
source "$HOME/dotfiles/scripts/helpers.sh"

# Make sure we are using zsh
if [ "$(command -v zsh)" != "$SHELL" ]; then
  echo "$XMARK Shell is not zsh"
  if [ "$OS" == "Darwin" ]; then
    # Run latest zsh from homebrew
    if ! isHomebrewPackageInstalled zsh; then
      echo "  $XMARK zsh not installed"
      echo "    $ARROW Installing homebrew zsh..."
      brew install zsh
    fi
    echo "  $CMARK zsh installed"

    if grep -q "$(command -v zsh)" /etc/shells; then
      echo "Adding homebrew zsh to accepted shell list (requires sudo)"
      sudo sh -c 'command -v zsh >> /etc/shells'
    fi
  elif command -v apt-get > /dev/null; then
    installAptPackageIfMissing zsh
  else
    echo "  $XMARK Unsupported OS. Install zsh on your own"
    exit 1
  fi

  if [ "$USER" = "ubuntu" ]; then
    echo "$XMARK Cannot change shell on password-less users (e.g. EC2 default)"
    exit 0
  else
    echo "  $ARROW Switching shell to zsh (will prompt for password)"
    chsh -s "$(command -v zsh)"

    echo "$CMARK zsh shell will be active in a terminals/login"
    exit 0
  fi
fi

echo "$CMARK Shell is zsh"
