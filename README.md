# Doug's macOS dev setup

A repeatable, documented setup for my macOS development environment.

## What this does
- Restores Homebrew packages via `Brewfile`
- Installs WezTerm as the primary terminal emulator
- Clones zsh framework `zsh-quickstart-kit` and links `~/.zshrc`
- Clones tmux framework `gpakosz/.tmux` and links `~/.tmux.conf`
- Installs/updates Doom Emacs (`~/.config/emacs`) and uses your config from `~/.config/doom`
- Captures editor configs:
  - VSCode `User` dir -> `dotfiles/editors/vscode` (also exports extensions.txt)
  - Cursor `User` dir -> `dotfiles/editors/cursor` (also exports extensions.txt)
- Symlinks personal dotfiles: `.gitconfig`, `.p10k.zsh`, `.tmux.conf.local`, `.zprofile`, `.config/doom/`, editor settings
- Additional configs captured:
  - Shell: `.zsh_aliases`, `.zshrc.d/`, `.zshrc.pre-plugins.d/`
  - XDG: `.config/mise/`, `.config/wezterm/`, `.config/htop/`, `.config/git/`, `.config/gh/` (safe subset: `config.yml` + extensions list)

## Install inventory
- Full install and setup documentation: `docs/installs.md`
- Exhaustive audit report (2026-02-22): `docs/install-audit-2026-02-22.md`

## Prerequisites (before cloning)
1. Install 1Password (desktop app) and sign in
2. Enable the SSH agent: 1Password > Settings > Developer > SSH Agent
3. Add your SSH key to 1Password (or confirm it is synced from another device)
4. Create the SSH directory if needed:
   ```
   mkdir -p ~/.ssh && chmod 700 ~/.ssh
   ```
5. Edit `~/.ssh/config` (append if it already exists) and add:
   ```
   Host github.com
       IdentityAgent ~/.1password/agent.sock
   ```
6. Verify SSH auth works:
   - `ssh -T git@github.com`

### SSH access to this machine
If you SSH into this machine, the 1Password agent socket may be reachable but key
use still requires biometric approval on the local GUI. For remote workflows, use
SSH agent forwarding from your client machine (`ssh -A` or `ForwardAgent yes`
per-host on the client). Do not enable `ForwardAgent yes` globally.

## One-time bootstrap (new machine)
1) Install Xcode Command Line Tools (GUI pops up):
   - Run: `xcode-select --install`
2) Install Homebrew if missing:
   - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3) Clone this repo and run setup:
   - `git clone <your-remote-url> ~/Developer/dotfiles`
   - `cd ~/Developer/dotfiles && ./scripts/setup.sh`
   - If you already cloned to `~/Development/dotfiles`, prefer moving it only if `~/Developer/dotfiles` does not already exist.

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
- Secrets (SSH/GPG keys, tokens) are NOT stored here. GitHub CLI authentication and Raycast state are intentionally not synced. Re-authenticate on new machines as needed.
- Python tooling/version management is handled with `uv`; other language runtimes are managed with `mise`.
- zsh prompt uses Powerlevel10k (`~/.p10k.zsh`).
- tmux uses Oh My Tmux with local overrides in `~/.tmux.conf.local`.
- GitHub CLI auth is manual after setup: run `gh auth login`.
