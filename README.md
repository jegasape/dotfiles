# Dotfiles

Includes:
- **Zsh** (`.zshrc` with lazy-loading of nvm/bun, starship cache, git auto-signoff)
- **LunarVim** (`~/.config/lvim/config.lua`)
- **Ghostty** terminal (`~/.config/ghostty/config`)
- **Git** (`.gitconfig`)
- **Starship** prompt (`~/.config/starship.toml`)
- Toolchains: **nvm + Node LTS**, **Bun**, **Go**, **Rust/Cargo**, **Docker + compose**
- CLI tools: `xclip`, `wl-clipboard`, `batcat`, `ripgrep`, `fd-find`, `fzf`, `xdg-utils`
- Zsh plugin: **fast-syntax-highlighting** (cloned to `~/fast-syntax-highlighting`)
- Font: **JetBrainsMono Nerd Font**

---

## Quick install (new machine)

```bash
cd ~/dotfiles
chmod +x install.sh packages.sh bootstrap.sh
./install.sh
```

`install.sh` runs three phases:

1. `packages.sh` — installs apt packages, nvm + Node LTS, Neovim AppImage v0.9.5, Rust, Go (latest stable), Bun, Docker + compose plugin, fast-syntax-highlighting, pynvim, Starship, and JetBrainsMono Nerd Font.
2. Verifies LunarVim dependencies and installs LunarVim.
3. Switches the default shell to zsh and runs `bootstrap.sh` to create the symlinks with Stow.

---

## Dirs 

```
dotfiles/
├── install.sh
├── packages.sh
├── bootstrap.sh
├── zsh/
│   └── .zshrc
├── git/
│   └── .gitconfig
├── starship/
│   └── .config/
│       └── starship.toml
├── ghostty/
│   └── .config/
│       └── ghostty/
│           └── config
└── lvim/
    └── .config/
        └── lvim/
            └── config.lua
```

Each top-level folder is a Stow "package". For example, `stow zsh` creates the symlink `~/.zshrc -> ~/dotfiles/zsh/.zshrc`.

## Manual Stow usage

```bash
cd ~/dotfiles

stow zsh
stow git
stow starship
stow lvim
stow ghostty

stow */

stow -D zsh

stow -R zsh
```

