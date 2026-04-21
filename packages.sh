#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log()  { echo -e "${GREEN}==>${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }

log "Updating apt indices..."
sudo apt update

APT_PACKAGES=(
  zsh
  stow
  git
  vim
  xclip
  wl-clipboard
  bat
  xdg-utils
  build-essential
  cmake
  pkg-config
  libssl-dev
  curl
  wget
  unzip
  ca-certificates
  gnupg
  python3
  python3-pip
  python3-venv
  python-is-python3
  ripgrep
  fd-find
  fzf
  fontconfig
)

log "Installing apt packages..."
sudo apt install -y "${APT_PACKAGES[@]}"

log "Installing FUSE library for AppImage support..."
if apt-cache show libfuse2t64 &>/dev/null; then
  sudo apt install -y libfuse2t64
else
  sudo apt install -y libfuse2
fi

NVM_VERSION="v0.40.1"
export NVM_DIR="$HOME/.nvm"

if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  log "Installing nvm $NVM_VERSION..."
  PROFILE=/dev/null bash -c \
    "curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash"
else
  log "nvm already installed"
fi

set +u
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"

if ! command -v node &>/dev/null; then
  log "Installing Node LTS via nvm..."
  nvm install --lts
  nvm alias default 'lts/*'
else
  log "Node already installed ($(node -v))"
fi

log "Installing global npm packages (neovim, tree-sitter-cli)..."
npm install -g neovim tree-sitter-cli
set -u

NVIM_VERSION="v0.9.5"
NVIM_BIN="$HOME/.local/bin/nvim"
NEED_NVIM=true
if [[ -x "$NVIM_BIN" ]]; then
  INSTALLED_VER="$("$NVIM_BIN" --version | head -1 | awk '{print $2}')"
  if [[ "$INSTALLED_VER" == "$NVIM_VERSION" ]]; then
    NEED_NVIM=false
    log "Neovim $NVIM_VERSION already installed"
  else
    log "Neovim $INSTALLED_VER found, replacing with $NVIM_VERSION"
  fi
fi

if $NEED_NVIM; then
  log "Installing Neovim $NVIM_VERSION AppImage at $NVIM_BIN..."
  mkdir -p "$HOME/.local/bin"
  curl -fsSL -o "$NVIM_BIN" \
    "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage"
  chmod +x "$NVIM_BIN"
  export PATH="$HOME/.local/bin:$PATH"
fi

if ! command -v cargo &>/dev/null; then
  log "Installing Rust toolchain..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  source "$HOME/.cargo/env"
else
  log "Rust already installed ($(cargo --version))"
fi

if ! command -v go &>/dev/null || [[ ! -d /usr/local/go ]]; then
  log "Installing Go (latest stable)..."
  GO_VERSION="$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -1)"
  GO_TARBALL="${GO_VERSION}.linux-amd64.tar.gz"
  curl -fsSL -o "/tmp/${GO_TARBALL}" "https://go.dev/dl/${GO_TARBALL}"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "/tmp/${GO_TARBALL}"
  rm "/tmp/${GO_TARBALL}"
  log "Go $GO_VERSION installed at /usr/local/go"
else
  log "Go already installed ($(go version))"
fi

if [[ ! -x "$HOME/.bun/bin/bun" ]]; then
  log "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
else
  log "Bun already installed ($("$HOME/.bun/bin/bun" --version))"
fi

if ! command -v docker &>/dev/null; then
  log "Installing Docker via official script..."
  curl -fsSL https://get.docker.com | sudo sh
  sudo usermod -aG docker "$USER"
  warn "Your user was added to the 'docker' group. Log out and log back in"
  warn "to run 'docker' without sudo."
else
  log "Docker already installed ($(docker --version))"
fi

if ! docker compose version &>/dev/null; then
  log "Installing docker-compose-v2 plugin..."
  sudo apt install -y docker-compose-plugin || \
    warn "Could not install docker-compose-plugin from apt. It usually ships with get.docker.com."
fi

if [[ ! -d "$HOME/fast-syntax-highlighting" ]]; then
  log "Cloning fast-syntax-highlighting..."
  git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
    "$HOME/fast-syntax-highlighting"
else
  log "fast-syntax-highlighting already present"
fi

log "Installing pynvim..."
if python3 -m pip install --help 2>&1 | grep -q "break-system-packages"; then
  python3 -m pip install --user --break-system-packages --upgrade pynvim
else
  python3 -m pip install --user --upgrade pynvim
fi

if ! command -v starship &>/dev/null; then
  log "Installing Starship..."
  curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
else
  log "Starship already installed ($(starship --version | head -1))"
fi

FONT_DIR="$HOME/.local/share/fonts"
if ! fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font Mono"; then
  log "Installing JetBrainsMono Nerd Font..."
  mkdir -p "$FONT_DIR/JetBrainsMonoNerdFont"
  TMP_FONT="$(mktemp -d)"
  curl -fsSL -o "$TMP_FONT/JetBrainsMono.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -qq -o "$TMP_FONT/JetBrainsMono.zip" -d "$FONT_DIR/JetBrainsMonoNerdFont"
  rm -rf "$TMP_FONT"
  fc-cache -f "$FONT_DIR" >/dev/null
  log "Font installed at $FONT_DIR/JetBrainsMonoNerdFont"
else
  log "JetBrainsMono Nerd Font already installed"
fi

log "Packages and dependencies ready."
