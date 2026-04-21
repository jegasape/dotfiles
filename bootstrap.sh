#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log()  { echo -e "${GREEN}==>${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }

if ! command -v stow &>/dev/null; then
  echo "stow is not installed. Run ./packages.sh first" >&2
  exit 1
fi

PACKAGES=(zsh git starship lvim ghostty)

BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

backup_if_real() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    warn "Moving $target -> $BACKUP_DIR/"
    mv "$target" "$BACKUP_DIR/"
  fi
}

backup_if_real "$HOME/.zshrc"
backup_if_real "$HOME/.gitconfig"
backup_if_real "$HOME/.config/starship.toml"
backup_if_real "$HOME/.config/lvim/config.lua"
backup_if_real "$HOME/.config/ghostty/config"

if [[ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
  rmdir "$BACKUP_DIR"
else
  log "Original files saved at: $BACKUP_DIR"
fi

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/ghostty"
mkdir -p "$HOME/.config/lvim"

for pkg in "${PACKAGES[@]}"; do
  if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
    log "Stowing $pkg..."
    stow --no-folding --restow --target="$HOME" "$pkg"
  else
    warn "Package '$pkg' does not exist, skipping."
  fi
done

log "Symlinks created. Check with: ls -la ~/.zshrc"
