#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
log()  { echo -e "${GREEN}==>${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[x]${NC} $*" >&2; }

if [[ $EUID -eq 0 ]]; then
  err "Do not run this script as root. Use your regular user (sudo will be requested when needed)."
  exit 1
fi

log "Dotfiles dir: $DOTFILES_DIR"

log "STEP 1/4 - Installing packages and dependencies..."
bash "$DOTFILES_DIR/packages.sh"

log "STEP 2/4 - Verifying and installing LunarVim..."

export NVM_DIR="$HOME/.nvm"
export PATH="$HOME/.local/bin:/usr/local/go/bin:$HOME/.bun/bin:$PATH"
set +u
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
[[ -s "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
set -u

if ! command -v lvim &>/dev/null; then
  MISSING=()
  for dep in nvim git make pip3 python3 npm node cargo rg; do
    command -v "$dep" &>/dev/null || MISSING+=("$dep")
  done

  if (( ${#MISSING[@]} > 0 )); then
    err "Missing LunarVim dependencies: ${MISSING[*]}"
    err "Check packages.sh. Aborting."
    exit 1
  fi

  log "All dependencies OK. Launching LunarVim installer..."
  LV_BRANCH='release-1.4/neovim-0.9' \
    bash <(curl -fsSL https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) \
    --no-install-dependencies --yes
else
  log "LunarVim already installed"
fi

log "STEP 3/4 - Default shell and symlinks..."

if [[ "$SHELL" != *"zsh"* ]]; then
  log "Changing default shell to zsh..."
  chsh -s "$(command -v zsh)"
  warn "Log out and log back in for zsh to become your shell."
else
  log "Zsh is already your default shell"
fi

log "Creating symlinks with Stow..."
bash "$DOTFILES_DIR/bootstrap.sh"

log "STEP 4/4 - Final sanity check..."
CHECK_FAILED=0

check_cmd() {
  if command -v "$1" &>/dev/null; then
    log "  [OK] $1 ($("$1" --version 2>/dev/null | head -1 || echo found))"
  else
    err "  [MISSING] $1"
    CHECK_FAILED=1
  fi
}

check_path() {
  local label="$1" path="$2" flag="$3"
  if test "$flag" "$path"; then
    log "  [OK] $label"
  else
    err "  [MISSING] $label"
    CHECK_FAILED=1
  fi
}

check_cmd zsh
check_cmd git
check_cmd stow
check_cmd xclip
check_cmd wl-copy
check_cmd batcat
check_cmd rg
check_cmd fdfind
check_cmd fzf
check_cmd nvim
check_cmd lvim
check_cmd starship
check_cmd cargo
check_cmd go
check_cmd docker

check_path "bun"                       "$HOME/.bun/bin/bun"              -x
check_path "nvm"                       "$HOME/.nvm/nvm.sh"               -s
check_path "fast-syntax-highlighting"  "$HOME/fast-syntax-highlighting"  -d
check_path ".zshrc symlink"            "$HOME/.zshrc"                    -L
check_path ".gitconfig symlink"        "$HOME/.gitconfig"                -L
check_path "starship.toml symlink"     "$HOME/.config/starship.toml"              -L
check_path "ghostty config symlink"    "$HOME/.config/ghostty/config"             -L
check_path "lvim config.lua symlink"   "$HOME/.config/lvim/config.lua"            -L
check_path "lvim lazy-lock symlink"    "$HOME/.config/lvim/lazy-lock.json"        -L
check_path "lvim user modules symlink" "$HOME/.config/lvim/lua/user/dashboard.lua" -L

if fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font Mono"; then
  log "  [OK] JetBrainsMono Nerd Font"
else
  err "  [MISSING] JetBrainsMono Nerd Font"
  CHECK_FAILED=1
fi

if (( CHECK_FAILED == 0 )); then
  log "Installation complete. Everything verified."
else
  err "Installation finished with warnings. Review the [MISSING] items above."
  exit 1
fi

echo
warn "Final steps:"
echo "  1. Log out and back in (for zsh + docker group)."
echo "  2. Open LunarVim with 'lvim' so it downloads plugins."
