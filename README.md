# Doug's macOS dev setup

A repeatable, documented setup for my macOS development environment.

## What this does
- Restores Homebrew packages via `Brewfile`
- Clones zsh framework `zsh-quickstart-kit` and links `~/.zshrc`
- Clones tmux framework `gpakosz/.tmux` and links `~/.tmux.conf`
- Installs/updates Doom Emacs (`~/.emacs.d`) and uses your config from `~/.doom.d`
- Symlinks personal dotfiles: `.gitconfig`, `.p10k.zsh`, `.tmux.conf.local`, `.zprofile`, `.doom.d/`

## One-time bootstrap (new machine)
1) Install Xcode Command Line Tools (GUI pops up):
   - Run: `xcode-select --install`
2) Install Homebrew if missing:
   - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3) Clone this repo and run setup:
   - `git clone <your-remote-url> ~/Developer/dotfiles`
   - `cd ~/Developer/dotfiles && ./scripts/setup.sh`

## Re-run after changes
- Update packages and links:
  - `./scripts/setup.sh` (idempotent)
- Re-dump current Homebrew state:
  - `brew bundle dump --file ./Brewfile --describe --no-restart -f`
- Re-sync editor configs (e.g., after editing Doom / VSCode / Cursor settings locally):
  - `./scripts/sync-from-home.sh`

## Notes
- Secrets (SSH/GPG keys, tokens) are NOT stored here. SSH agent is handled via 1Password when available.
- zsh prompt uses Powerlevel10k (`~/.p10k.zsh`).
- tmux uses Oh My Tmux with local overrides in `~/.tmux.conf.local`.
