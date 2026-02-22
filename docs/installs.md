# Install Inventory

## Scope and Source of Truth

This document inventories what this repo installs or bootstraps via `Brewfile`, `scripts/*.sh`, and tracked dotfiles/config. It is the durable companion to `README.md` and the more detailed audit findings.

Audit baseline: February 22, 2026 (Apple Silicon macOS, Homebrew at `/opt/homebrew`).

- Package source of truth: `Brewfile`
- Bootstrap behavior source of truth: `scripts/setup.sh` and helper scripts
- Tracked config source of truth: `dotfiles/`
- Exhaustive audit report (2026-02-22): `docs/install-audit-2026-02-22.md`

## Primary Terminal

WezTerm is the primary and only terminal emulator managed by this repo. Ghostty has been removed from the managed setup.

- App install: `Brewfile` (`cask "wezterm"`)
- Local config path: `~/.config/wezterm/wezterm.lua`
- Repo config path: `dotfiles/config/wezterm/wezterm.lua`
- Docs: [WezTerm install](https://wezterm.org/install/macos.html), [WezTerm config files](https://wezterm.org/config/files.html)

## Bootstrap Prerequisites (Manual)

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| Xcode Command Line Tools | Manual | Compiler/toolchain prerequisites for Homebrew and native builds | Run `xcode-select --install` | N/A | Required before running `./scripts/setup.sh`. |
| Homebrew | Manual (if missing) + `scripts/setup.sh` shellenv | Package manager used by `Brewfile` restore | Install if missing, then rerun setup | `/opt/homebrew` | `scripts/setup.sh` handles shellenv after install. |
| 1Password Desktop App | Manual | Required for 1Password SSH agent and CLI workflows | Sign in and enable SSH agent | App-managed | See README prerequisites. |

## Script-Managed Installs

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| zgenom | `scripts/install-zsh-quickstart.sh` | Plugin manager used by zsh-quickstart-kit | None beyond clone/update; verify shell startup | `~/.zgenom` | Installed before zsh-quickstart-kit. |
| zsh-quickstart-kit | `scripts/install-zsh-quickstart.sh` | zsh framework and managed `~/.zshrc` target | Open new terminal and verify prompt/plugins | `~/zsh-quickstart-kit` + `~/.zshrc` symlink | Repo also links `.zshrc.d` and `.zshrc.pre-plugins.d`. |
| Oh My Tmux (`gpakosz/.tmux`) | `scripts/install-oh-my-tmux.sh` | tmux framework defaults | Verify `~/.tmux.conf` and launch tmux | `~/.tmux`, `~/.tmux.conf`, `~/.tmux.conf.local` | Local overrides tracked in repo. |
| Doom Emacs | `scripts/install-doom.sh` | Emacs distribution layered on `emacs-plus` | Fresh install runs `doom install`; reruns use `doom upgrade` | `~/.config/emacs` + `~/.config/doom` | Migrates legacy `~/.doom.d` on first XDG install if needed. |

## Homebrew Taps

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`d12frosted/emacs-plus`](https://github.com/d12frosted/emacs-plus) | Brewfile (tap) | Additional Homebrew formula source | None | N/A | Required by one or more formulas in `Brewfile`. |
| [`jondot/tap`](https://github.com/jondot/tap) | Brewfile (tap) | Additional Homebrew formula source | None | N/A | Required by one or more formulas in `Brewfile`. |
| [`tilt-dev/tap`](https://github.com/tilt-dev/tap) | Brewfile (tap) | Additional Homebrew formula source | None | N/A | Required by one or more formulas in `Brewfile`. |

## Homebrew Formulae

Formulae are grouped for readability. Linked names point to Homebrew Formula pages.

### Core shell/tooling

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`awk`](https://formulae.brew.sh/formula/awk) | Brewfile (brew) | Text processing scripting language | None (install only) | N/A |  |
| [`bash`](https://formulae.brew.sh/formula/bash) | Brewfile (brew) | Bourne-Again SHell, a UNIX command interpreter | None (install only) | N/A |  |
| [`coreutils`](https://formulae.brew.sh/formula/coreutils) | Brewfile (brew) | GNU File, Shell, and Text utilities | None (install only) | N/A |  |
| [`curl`](https://formulae.brew.sh/formula/curl) | Brewfile (brew) | Get a file from an HTTP, HTTPS or FTP server | None (install only) | N/A |  |
| [`fd`](https://formulae.brew.sh/formula/fd) | Brewfile (brew) | Simple, fast and user-friendly alternative to find | None (install only) | N/A |  |
| [`fzf`](https://formulae.brew.sh/formula/fzf) | Brewfile (brew) | Command-line fuzzy finder written in Go | zsh-quickstart-kit typically wires integration; verify key bindings/completion in a new shell. | Managed by zsh framework | No separate `fzf --install` step planned. |
| [`gawk`](https://formulae.brew.sh/formula/gawk) | Brewfile (brew) | GNU awk utility | None (install only) | N/A |  |
| [`htop`](https://formulae.brew.sh/formula/htop) | Brewfile (brew) | Improved top (interactive process viewer) | None (install only) | N/A |  |
| [`jq`](https://formulae.brew.sh/formula/jq) | Brewfile (brew) | Lightweight and flexible command-line JSON processor | None (install only) | N/A |  |
| [`make`](https://formulae.brew.sh/formula/make) | Brewfile (brew) | Utility for directing compilation | None (install only) | N/A |  |
| [`ripgrep`](https://formulae.brew.sh/formula/ripgrep) | Brewfile (brew) | Search tool like grep and The Silver Searcher | None (install only) | N/A |  |
| [`rsync`](https://formulae.brew.sh/formula/rsync) | Brewfile (brew) | Utility that provides fast incremental file transfer | None (install only) | N/A |  |
| [`stow`](https://formulae.brew.sh/formula/stow) | Brewfile (brew) | Organize software neatly under a single directory tree (e.g. /usr/local) | None (install only) | N/A |  |
| [`tree`](https://formulae.brew.sh/formula/tree) | Brewfile (brew) | Display directories as trees (with optional color/HTML output) | None (install only) | N/A |  |
| [`urlview`](https://formulae.brew.sh/formula/urlview) | Brewfile (brew) | URL extractor/launcher | None (install only) | N/A |  |
| [`mise`](https://formulae.brew.sh/formula/mise) | Brewfile (brew) | Polyglot runtime/version manager (used for non-Python runtimes) | Verify zsh activation and `mise doctor`; Python is intentionally managed with `uv`. | `~/.config/mise` | Config tracked in `dotfiles/config/mise`. |
| [`uv`](https://formulae.brew.sh/formula/uv) | Brewfile (brew) | Extremely fast Python package installer and resolver, written in Rust | Shell completions are sourced in `zshrc.d/001.zshrc`; verify startup. | zsh config | Both `uv` and `uvx` completion evals are configured. |
| [`wget`](https://formulae.brew.sh/formula/wget) | Brewfile (brew) | Internet file retriever | None (install only) | N/A |  |
| [`zoxide`](https://formulae.brew.sh/formula/zoxide) | Brewfile (brew) | Shell extension to navigate your filesystem faster | Shell init should be provided by zsh config; verify `zoxide query` works. | zsh init | Check startup after bootstrap. |
| [`zsh`](https://formulae.brew.sh/formula/zsh) | Brewfile (brew) | UNIX shell (command interpreter) | None (install only) | N/A |  |

### Git/GitHub

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`gh`](https://formulae.brew.sh/formula/gh) | Brewfile (brew) | GitHub command-line tool | `gh auth login` after bootstrap; decide SSH vs HTTPS and confirm with `gh auth status`. | `~/.config/gh/config.yml` (safe subset tracked) | Authentication tokens are not tracked. |
| [`git`](https://formulae.brew.sh/formula/git) | Brewfile (brew) | Distributed revision control system | None (install only) | N/A |  |
| [`git-delta`](https://formulae.brew.sh/formula/git-delta) | Brewfile (brew) | Syntax-highlighting pager for git and diff output | None (install only) | N/A |  |

### Cloud/infra CLIs

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`awscli`](https://formulae.brew.sh/formula/awscli) | Brewfile (brew) | Official Amazon AWS command-line interface | `aws configure` or SSO setup (`aws configure sso`); verify with `aws sts get-caller-identity`. | N/A | Requires credentials outside repo. |
| [`heroku`](https://formulae.brew.sh/formula/heroku) | Brewfile (brew) | CLI for Heroku | `heroku login` after install. | N/A | Auth is manual and not tracked. |
| [`kubernetes-cli`](https://formulae.brew.sh/formula/kubernetes-cli) | Brewfile (brew) | Kubernetes command-line interface | Provide kubeconfig (`~/.kube/config`) and verify with `kubectl config get-contexts`. | `~/.kube/config` (not tracked) | No cluster credentials are tracked. |
| [`tilt-dev/tap/tilt`](https://formulae.brew.sh/formula/tilt) | Brewfile (brew) | A dev environment as code for microservice apps | Install/configure local Kubernetes context before use; verify with `tilt version`. | Project-local `Tiltfile`s | Tap formula. |

### Databases/services

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`libpq`](https://formulae.brew.sh/formula/libpq) | Brewfile (brew) | Postgres C API library | None (install only) | N/A |  |

### Build/toolchains

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`cmake`](https://formulae.brew.sh/formula/cmake) | Brewfile (brew) | Cross-platform make | None (install only) | N/A |  |
| [`gcc`](https://formulae.brew.sh/formula/gcc) | Brewfile (brew) | GNU compiler collection | None (install only) | N/A |  |
| [`open-mpi`](https://formulae.brew.sh/formula/open-mpi) | Brewfile (brew) | High performance message passing library | None (install only) | N/A |  |
| [`pkgconf`](https://formulae.brew.sh/formula/pkgconf) | Brewfile (brew) | Package compiler and linker metadata toolkit | None (install only) | N/A |  |

### Language runtimes

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`erlang`](https://formulae.brew.sh/formula/erlang) | Brewfile (brew) | Programming language for highly scalable real-time systems | None (install only) | N/A |  |
| [`yarn`](https://formulae.brew.sh/formula/yarn) | Brewfile (brew) | JavaScript package manager | None (install only) | N/A |  |

### Terminal/editor support

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`d12frosted/emacs-plus/emacs-plus@30`](https://formulae.brew.sh/formula/emacs-plus@30) | Brewfile (brew) | GNU Emacs text editor | Patch config is linked before `brew bundle`; Doom bootstrap runs separately. | `~/.config/emacs-plus` + `/Applications/Emacs.app` alias (best effort) | Emacs app aliases are created after brew restore. |
| [`ispell`](https://formulae.brew.sh/formula/ispell) | Brewfile (brew) | International Ispell | None (install only) | N/A |  |
| [`libgccjit`](https://formulae.brew.sh/formula/libgccjit) | Brewfile (brew) | JIT library for the GNU compiler collection | None (install only) | N/A |  |
| [`libvterm`](https://formulae.brew.sh/formula/libvterm) | Brewfile (brew) | C99 library which implements a VT220 or xterm terminal emulator | None (install only) | N/A |  |
| [`tmux`](https://formulae.brew.sh/formula/tmux) | Brewfile (brew) | Terminal multiplexer | Framework scripts handle setup; verify `tmux -V` and config load. | `~/.tmux.conf` + `~/.tmux.conf.local` | Oh My Tmux is script-managed. |

### Media/OCR/image/PDF

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`giflib`](https://formulae.brew.sh/formula/giflib) | Brewfile (brew) | Library and utilities for processing GIFs | None (install only) | N/A |  |
| [`harfbuzz`](https://formulae.brew.sh/formula/harfbuzz) | Brewfile (brew) | OpenType text shaping engine | None (install only) | N/A |  |
| [`imagemagick`](https://formulae.brew.sh/formula/imagemagick) | Brewfile (brew) | Tools and libraries to manipulate images in many formats | None (install only) | N/A |  |
| [`jpeg`](https://formulae.brew.sh/formula/jpeg) | Brewfile (brew) | Image manipulation library | None (install only) | N/A |  |
| [`libpng`](https://formulae.brew.sh/formula/libpng) | Brewfile (brew) | Library for manipulating PNG images | None (install only) | N/A |  |
| [`librsvg`](https://formulae.brew.sh/formula/librsvg) | Brewfile (brew) | Library to render SVG files using Cairo | None (install only) | N/A |  |
| [`poppler`](https://formulae.brew.sh/formula/poppler) | Brewfile (brew) | PDF rendering library (based on the xpdf-3.0 code base) | None (install only) | N/A |  |
| [`shared-mime-info`](https://formulae.brew.sh/formula/shared-mime-info) | Brewfile (brew) | Database of common MIME types | None (install only) | N/A |  |
| [`tesseract`](https://formulae.brew.sh/formula/tesseract) | Brewfile (brew) | OCR (Optical Character Recognition) engine | None (install only) | N/A |  |
| [`vips`](https://formulae.brew.sh/formula/vips) | Brewfile (brew) | Image processing library | None (install only) | N/A |  |

### Utilities

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`cryptography`](https://formulae.brew.sh/formula/cryptography) | Brewfile (brew) | Cryptographic recipes and primitives for Python | None (install only) | N/A |  |
| [`extract_url`](https://formulae.brew.sh/formula/extract_url) | Brewfile (brew) | Perl script to extracts URLs from emails or plain text | None (install only) | N/A |  |
| [`fpp`](https://formulae.brew.sh/formula/fpp) | Brewfile (brew) | CLI program that accepts piped input and presents files for selection | None (install only) | N/A |  |
| [`glib`](https://formulae.brew.sh/formula/glib) | Brewfile (brew) | Core application library for C | None (install only) | N/A |  |
| [`gnupg`](https://formulae.brew.sh/formula/gnupg) | Brewfile (brew) | GNU Pretty Good Privacy (PGP) package | Import keys and configure pinentry/GPG agent as needed for signing. | `~/.gnupg` (not tracked) | Secrets not tracked. |
| [`libyaml`](https://formulae.brew.sh/formula/libyaml) | Brewfile (brew) | YAML Parser | None (install only) | N/A |  |
| [`overmind`](https://formulae.brew.sh/formula/overmind) | Brewfile (brew) | Process manager for Procfile-based applications and tmux | None (install only) | N/A |  |
| [`pixman`](https://formulae.brew.sh/formula/pixman) | Brewfile (brew) | Low-level library for pixel manipulation | None (install only) | N/A |  |

## Homebrew Casks

### Fonts

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| `SF Mono` (Apple) | `scripts/install-sf-mono.sh` (run by `scripts/setup.sh`) | Preferred WezTerm font on macOS | Copied from Terminal.app resources into `~/Library/Fonts` when available. | `~/.config/wezterm/wezterm.lua` | macOS-only; not distributed in this repo or Homebrew. |
| [`font-fira-code`](https://formulae.brew.sh/cask/font-fira-code) | Brewfile (cask) | macOS app/cask | None (launch/sign in as needed) | N/A |  |
| [`font-hack-nerd-font`](https://formulae.brew.sh/cask/font-hack-nerd-font) | Brewfile (cask) | Nerd Font icons for terminal prompt/theme support | None (launch/sign in as needed) | `~/.p10k.zsh` | Powerlevel10k is configured with `nerdfont-v3`. |
| [`font-roboto`](https://formulae.brew.sh/cask/font-roboto) | Brewfile (cask) | macOS app/cask | None (launch/sign in as needed) | N/A |  |

### Desktop apps

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`jordanbaird-ice`](https://formulae.brew.sh/cask/jordanbaird-ice) | Brewfile (cask) | Menu bar manager | Grant macOS permissions if prompted. | App-managed | GUI onboarding is manual. |
| [`spotify`](https://formulae.brew.sh/cask/spotify) | Brewfile (cask) | Music streaming service | Sign in manually. | App-managed | Optional personal app. |
| [`wezterm`](https://formulae.brew.sh/cask/wezterm) | Brewfile (cask) | GPU-accelerated cross-platform terminal emulator | Primary terminal. Config is tracked and linked; verify app launches and reads config. | `~/.config/wezterm/wezterm.lua` | Replaces Ghostty in this setup. |

### Cloud/infra CLIs

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`1password-cli`](https://formulae.brew.sh/cask/1password-cli) | Brewfile (cask) | Command-line interface for 1Password | Requires 1Password desktop app and sign-in; run `op signin` as needed. | N/A | SSH agent setup is documented in README. |
| [`ngrok`](https://formulae.brew.sh/cask/ngrok) | Brewfile (cask) | Reverse proxy, secure introspectable tunnels to localhost | Authenticate with `ngrok config add-authtoken <token>`. | `~/.config/ngrok` (not tracked) | Token is manual and not tracked. |
| [`session-manager-plugin`](https://formulae.brew.sh/cask/session-manager-plugin) | Brewfile (cask) | Plugin for AWS CLI to start and end sessions that connect to managed instances | Verify `session-manager-plugin` is available for AWS SSM CLI workflows. | N/A | Used by AWS Session Manager. |

## VS Code Extensions

These are restored via `brew bundle` `vscode` entries. VS Code/Cursor apps themselves are installed manually.

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| [`anysphere.cursorpyright`](https://marketplace.visualstudio.com/items?itemName=anysphere.cursorpyright) | Brewfile (vscode) | Python type checking (CursorPyright) | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`bierner.markdown-mermaid`](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid) | Brewfile (vscode) | Mermaid diagram previews | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`catppuccin.catppuccin-vsc`](https://marketplace.visualstudio.com/items?itemName=catppuccin.catppuccin-vsc) | Brewfile (vscode) | Theme | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`charliermarsh.ruff`](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff) | Brewfile (vscode) | Python lint/format integration | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`datadog.datadog-vscode`](https://marketplace.visualstudio.com/items?itemName=datadog.datadog-vscode) | Brewfile (vscode) | Datadog integration | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`esbenp.prettier-vscode`](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) | Brewfile (vscode) | Prettier formatter | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`github.vscode-github-actions`](https://marketplace.visualstudio.com/items?itemName=github.vscode-github-actions) | Brewfile (vscode) | GitHub Actions support | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`mcaragheorghe.vim-enhanced`](https://marketplace.visualstudio.com/items?itemName=mcaragheorghe.vim-enhanced) | Brewfile (vscode) | Vim workflow helpers | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`mechatroner.rainbow-csv`](https://marketplace.visualstudio.com/items?itemName=mechatroner.rainbow-csv) | Brewfile (vscode) | CSV/TSV highlighting | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`ms-azuretools.vscode-containers`](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers) | Brewfile (vscode) | Container tools | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`ms-azuretools.vscode-docker`](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) | Brewfile (vscode) | Docker tools | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`ms-python.debugpy`](https://marketplace.visualstudio.com/items?itemName=ms-python.debugpy) | Brewfile (vscode) | Python debugger backend | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`ms-python.python`](https://marketplace.visualstudio.com/items?itemName=ms-python.python) | Brewfile (vscode) | Python extension | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`ms-vscode.makefile-tools`](https://marketplace.visualstudio.com/items?itemName=ms-vscode.makefile-tools) | Brewfile (vscode) | Makefile integration | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`shopify.ruby-lsp`](https://marketplace.visualstudio.com/items?itemName=shopify.ruby-lsp) | Brewfile (vscode) | Ruby language server | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`vscodevim.vim`](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim) | Brewfile (vscode) | Vim emulation | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |
| [`waderyan.gitblame`](https://marketplace.visualstudio.com/items?itemName=waderyan.gitblame) | Brewfile (vscode) | Inline git blame | Ensure editor CLI exists for restore/listing workflows. | `dotfiles/editors/vscode` and `dotfiles/editors/cursor` | Extension ID only; actual editor app install is manual. |

## Configured but Not Installed by Brewfile

| Name | Installed By | Purpose | Post-Install Setup | Config Path | Notes |
|---|---|---|---|---|---|
| Raycast | Manual install (not in Brewfile) | Launcher/productivity app | Install/sign in manually if used | App-managed | Repo no longer syncs Raycast config because it contains secrets/generated state. |
| Visual Studio Code | Manual install (not in Brewfile) | Editor used by sync scripts | Install app to `/Applications/Visual Studio Code.app` | `~/Library/Application Support/Code/User` | `sync-editors.sh` reads and exports this path. |
| Cursor | Manual install (not in Brewfile) | Editor used by sync scripts | Install app to `/Applications/Cursor.app` | `~/Library/Application Support/Cursor/User` | `sync-editors.sh` reads and exports this path. |

## Post-Install Setup Checklist

- Run `gh auth login` and verify with `gh auth status`.
- Configure AWS credentials/SSO (`aws configure` or `aws configure sso`) if you use AWS.
- Verify `session-manager-plugin` if you use AWS Systems Manager sessions.
- Install/confirm VS Code and Cursor apps if you use the editor sync/restore workflow.
- Open WezTerm and confirm it reads `~/.config/wezterm/wezterm.lua`.
- Run `~/.config/emacs/bin/doom doctor` after Doom bootstrap.
- Open a new terminal and confirm zsh prompt/plugins/completions (zgenom, fzf, zoxide, uv, mise) work.
- Use `uv` for Python versions/tooling (`uv python install`, `uv python pin`) and `mise` for other runtimes.

## Services and How to Start/Verify

No local database/broker services are currently installed by `Brewfile`.

## Security Notes

- This repo should not track secrets, tokens, or auth state files.
- `~/.config/gh/hosts.yml` is intentionally not tracked or linked.
- Raycast config/state syncing is disabled in this repo because it contains tokens and generated artifacts.
- 1Password SSH agent is the recommended SSH auth path and should be configured before cloning over SSH.
- Review diffs and run a secret scan before committing sync output.

## Update Procedure

1. Update `Brewfile`, scripts, or tracked dotfiles.
2. Run `./scripts/setup.sh` to validate bootstrap behavior on a target machine.
3. Re-sync safe home config with `./scripts/sync-from-home.sh`.
4. Re-sync editor settings with `./scripts/sync-editors.sh`.
5. If package set changed intentionally, refresh `Brewfile` with `brew bundle dump --file ./Brewfile --describe --no-restart -f`.
6. Review diffs for secrets or generated artifacts before committing.
7. Update this document when setup steps or package categories change.

### Setup-Sensitive References

- [Brew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile)
- [1Password SSH Agent](https://developer.1password.com/docs/ssh/agent/)
- [1Password CLI](https://developer.1password.com/docs/cli/get-started/)
- [Doom Emacs](https://github.com/doomemacs/doomemacs)
- [emacs-plus](https://github.com/d12frosted/homebrew-emacs-plus)
- [zsh-quickstart-kit](https://github.com/unixorn/zsh-quickstart-kit)
- [zgenom](https://github.com/jandamm/zgenom)
- [mise](https://mise.jdx.dev/)
- [Oh My Tmux](https://github.com/gpakosz/.tmux)
- [WezTerm (install)](https://wezterm.org/install/macos.html)
- [WezTerm (config)](https://wezterm.org/config/files.html)
- [GitHub CLI auth](https://cli.github.com/manual/gh_auth_login)
- [AWS CLI configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- [AWS Session Manager Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)
- [kubectl on macOS](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)
- [Tilt install](https://docs.tilt.dev/install.html)
- [ngrok getting started](https://ngrok.com/docs/getting-started/)
- [fzf](https://github.com/junegunn/fzf)
- [zoxide](https://zoxide.dev/)
