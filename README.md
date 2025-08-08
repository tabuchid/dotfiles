# Doug's macOS dev setup

A repeatable, documented setup for my macOS development environment.

## What this does
- Restores Homebrew packages via `Brewfile`
- Clones zsh framework `zsh-quickstart-kit` and links `~/.zshrc`
- Clones tmux framework `gpakosz/.tmux` and links `~/.tmux.conf`
- Installs/updates Doom Emacs (`~/.emacs.d`) and uses your config from `~/.doom.d`
- Captures editor configs:
  - VSCode `User` dir -> `dotfiles/editors/vscode` (also exports extensions.txt)
  - Cursor `User` dir -> `dotfiles/editors/cursor` (also exports extensions.txt)
- Symlinks personal dotfiles: `.gitconfig`, `.p10k.zsh`, `.tmux.conf.local`, `.zprofile`, `.doom.d/`, editor settings
- Additional configs captured:
  - Shell: `.zsh_aliases`, `.zshrc.d/`, `.zshrc.pre-plugins.d/`
  - XDG: `.config/mise/`, `.config/wezterm/`, `.config/ghostty/`, `.config/htop/`, `.config/git/`, `.config/raycast/`, `.config/gh/` (config.yml + extensions list)

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
- Re-sync editor configs (VSCode/Cursor):
  - `./scripts/sync-editors.sh`
- Re-sync dotfiles (Doom, gitconfig, etc.):
  - `./scripts/sync-from-home.sh`

## Restore VSCode/Cursor extensions on a new machine
- VSCode: `cat dotfiles/editors/vscode/extensions.txt | xargs -n1 "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" --install-extension`
- Cursor: `cat dotfiles/editors/cursor/extensions.txt | xargs -n1 "/Applications/Cursor.app/Contents/Resources/app/bin/cursor" --install-extension`

## Notes
- Secrets (SSH/GPG keys, tokens) are NOT stored here. GitHub CLI authentication, Raycast cloud data, etc., are excluded. Re-authenticate on new machines as needed.
- zsh prompt uses Powerlevel10k (`~/.p10k.zsh`).
- tmux uses Oh My Tmux with local overrides in `~/.tmux.conf.local`.
