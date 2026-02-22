# Install Setup Audit (Exhaustive)

Audit date: February 22, 2026

Scope: current repo state after the bootstrap/security/WezTerm changes. This is the formal audit artifact corresponding to the chat review (per-item matrix + citations).

Inventory counts reviewed: `3` taps, `60` formulae, `9` casks, `17` VS Code extensions, plus manual prerequisites, script-managed installs, and configured-but-not-Brewfile tools.

## Findings

1. `[P0]` No current repo-tracked secret/token exposure found in the reviewed paths after cleanup.
   - Evidence: Raycast state and `gh` auth state are no longer linked/synced (`/Users/tabuchid/Development/dotfiles/scripts/link.sh:24`, `/Users/tabuchid/Development/dotfiles/scripts/sync-from-home.sh:88`, `/Users/tabuchid/Development/dotfiles/README.md:69`, `/Users/tabuchid/Development/dotfiles/docs/installs.md:234`).
   - Impact: The prior token-bearing Raycast/GH auth risk is remediated in the repo baseline.

2. `[P2]` Machine state may not yet be converged to the `Brewfile` on a given host until `brew bundle install` / `./scripts/setup.sh` completes.
   - Evidence: Local verification can still report missing dependencies pre-bootstrap (user-local `brew bundle check`).
   - Impact: The repo definition is correct, but runtime availability is host-dependent until bootstrap completes.

3. `[P3]` VS Code/Cursor apps are intentionally out-of-band while extensions/settings subsets are managed.
   - Evidence: editor sync scripts read app-specific user dirs (`/Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29`, `/Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43`), and docs mark VS Code/Cursor manual (`/Users/tabuchid/Development/dotfiles/docs/installs.md:212`).
   - Impact: Extension restore/listing flows assume manual installation of the editor applications.

## Audit Matrix

Columns: `item_type`, `item_name`, `installed_by`, `config_path`, `requires_post_install_setup`, `required_setup_steps`, `status`, `evidence_local`, `sources`, `recommended_change`

### Manual Prereqs

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| external_prereq | Xcode Command Line Tools | manual (README bootstrap) | N/A | yes | Run `xcode-select --install` | ok | /Users/tabuchid/Development/dotfiles/README.md:44; /Users/tabuchid/Development/dotfiles/scripts/setup.sh:11 | https://developer.apple.com/xcode/resources/ | none |
| external_prereq | Homebrew bootstrap | manual if missing + scripts/setup.sh | /opt/homebrew | yes | Install if missing, then rerun `./scripts/setup.sh` | ok | /Users/tabuchid/Development/dotfiles/README.md:47; /Users/tabuchid/Development/dotfiles/scripts/setup.sh:18 | https://docs.brew.sh/Brew-Bundle-and-Brewfile | none |
| external_prereq | 1Password Desktop App + SSH Agent | manual (README prereqs) | ~/.ssh/config (IdentityAgent) | yes | Sign in, enable SSH agent, verify `ssh -T git@github.com` | ok | /Users/tabuchid/Development/dotfiles/README.md:22; /Users/tabuchid/Development/dotfiles/README.md:38 | https://developer.1password.com/docs/ssh/agent/; https://developer.1password.com/docs/cli/get-started/ | none |

### Script-Managed Installs

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| bootstrap_repo | zgenom | /Users/tabuchid/Development/dotfiles/scripts/install-zsh-quickstart.sh:6 | ~/.zgenom | yes | Clone/update via script; verify zsh starts cleanly | ok | /Users/tabuchid/Development/dotfiles/scripts/install-zsh-quickstart.sh:6; /Users/tabuchid/Development/dotfiles/scripts/setup.sh:106 | https://github.com/jandamm/zgenom | none |
| bootstrap_repo | zsh-quickstart-kit | /Users/tabuchid/Development/dotfiles/scripts/install-zsh-quickstart.sh:8 | ~/zsh-quickstart-kit; ~/.zshrc | yes | Open new terminal; verify `~/.zshrc` link + prompt | ok | /Users/tabuchid/Development/dotfiles/scripts/install-zsh-quickstart.sh:8; /Users/tabuchid/Development/dotfiles/scripts/setup.sh:106 | https://github.com/unixorn/zsh-quickstart-kit | none |
| bootstrap_repo | Oh My Tmux | /Users/tabuchid/Development/dotfiles/scripts/install-oh-my-tmux.sh:6 | ~/.tmux; ~/.tmux.conf; ~/.tmux.conf.local | yes | Verify `~/.tmux.conf` link; run `tmux -V` | ok | /Users/tabuchid/Development/dotfiles/scripts/install-oh-my-tmux.sh:6; /Users/tabuchid/Development/dotfiles/scripts/setup.sh:107 | https://github.com/gpakosz/.tmux | none |
| bootstrap_repo | Doom Emacs | /Users/tabuchid/Development/dotfiles/scripts/install-doom.sh:13 | ~/.config/emacs; ~/.config/doom | yes | Fresh: `doom install`; rerun: `doom upgrade`; verify `doom doctor` | ok | /Users/tabuchid/Development/dotfiles/scripts/install-doom.sh:13; /Users/tabuchid/Development/dotfiles/scripts/setup.sh:110 | https://github.com/doomemacs/doomemacs | none |

### Homebrew Taps

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| tap | d12frosted/emacs-plus | /Users/tabuchid/Development/dotfiles/Brewfile:1 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:1 | https://github.com/d12frosted/homebrew-emacs-plus | none |
| tap | jondot/tap | /Users/tabuchid/Development/dotfiles/Brewfile:2 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:2 | https://github.com/jondot/homebrew-tap | none |
| tap | tilt-dev/tap | /Users/tabuchid/Development/dotfiles/Brewfile:3 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:3 | https://github.com/tilt-dev/homebrew-tap | none |

### Homebrew Formulae

#### Core shell/tooling

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| brew | awk | /Users/tabuchid/Development/dotfiles/Brewfile:9 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:9 | https://formulae.brew.sh/formula/awk | none |
| brew | bash | /Users/tabuchid/Development/dotfiles/Brewfile:13 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:13 | https://formulae.brew.sh/formula/bash | none |
| brew | coreutils | /Users/tabuchid/Development/dotfiles/Brewfile:21 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:21 | https://formulae.brew.sh/formula/coreutils | none |
| brew | curl | /Users/tabuchid/Development/dotfiles/Brewfile:25 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:25 | https://formulae.brew.sh/formula/curl | none |
| brew | fd | /Users/tabuchid/Development/dotfiles/Brewfile:31 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:31 | https://formulae.brew.sh/formula/fd | none |
| brew | fzf | /Users/tabuchid/Development/dotfiles/Brewfile:39 | Shell init via zsh config | yes | Verify shell keybindings/completion after zsh startup | ok | /Users/tabuchid/Development/dotfiles/Brewfile:39 | https://formulae.brew.sh/formula/fzf; https://github.com/junegunn/fzf | none |
| brew | gawk | /Users/tabuchid/Development/dotfiles/Brewfile:41 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:41 | https://formulae.brew.sh/formula/gawk | none |
| brew | htop | /Users/tabuchid/Development/dotfiles/Brewfile:59 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:59 | https://formulae.brew.sh/formula/htop | none |
| brew | jq | /Users/tabuchid/Development/dotfiles/Brewfile:71 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:71 | https://formulae.brew.sh/formula/jq | none |
| brew | make | /Users/tabuchid/Development/dotfiles/Brewfile:85 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:85 | https://formulae.brew.sh/formula/make | none |
| brew | ripgrep | /Users/tabuchid/Development/dotfiles/Brewfile:99 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:99 | https://formulae.brew.sh/formula/ripgrep | none |
| brew | rsync | /Users/tabuchid/Development/dotfiles/Brewfile:101 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:101 | https://formulae.brew.sh/formula/rsync | none |
| brew | stow | /Users/tabuchid/Development/dotfiles/Brewfile:103 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:103 | https://formulae.brew.sh/formula/stow | none |
| brew | tree | /Users/tabuchid/Development/dotfiles/Brewfile:105 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:105 | https://formulae.brew.sh/formula/tree | none |
| brew | urlview | /Users/tabuchid/Development/dotfiles/Brewfile:107 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:107 | https://formulae.brew.sh/formula/urlview | none |
| brew | uv | /Users/tabuchid/Development/dotfiles/Brewfile:109 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:109 | https://formulae.brew.sh/formula/uv | none |
| brew | wget | /Users/tabuchid/Development/dotfiles/Brewfile:113 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:113 | https://formulae.brew.sh/formula/wget | none |
| brew | zoxide | /Users/tabuchid/Development/dotfiles/Brewfile:117 | Shell init via zsh config | yes | Verify shell init and `zoxide query` | ok | /Users/tabuchid/Development/dotfiles/Brewfile:117 | https://formulae.brew.sh/formula/zoxide; https://github.com/ajeetdsouza/zoxide | none |
| brew | zsh | /Users/tabuchid/Development/dotfiles/Brewfile:119 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:119 | https://formulae.brew.sh/formula/zsh | none |

#### Git/GitHub

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| brew | gh | /Users/tabuchid/Development/dotfiles/Brewfile:43 | ~/.config/gh/config.yml (safe subset); auth state untracked | yes | `gh auth login`; verify `gh auth status` | ok | /Users/tabuchid/Development/dotfiles/Brewfile:43; /Users/tabuchid/Development/dotfiles/scripts/link.sh:24; /Users/tabuchid/Development/dotfiles/scripts/sync-from-home.sh:88 | https://formulae.brew.sh/formula/gh; https://cli.github.com/manual/gh_auth_login | none |
| brew | git | /Users/tabuchid/Development/dotfiles/Brewfile:49 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:49 | https://formulae.brew.sh/formula/git | none |
| brew | git-delta | /Users/tabuchid/Development/dotfiles/Brewfile:51 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:51 | https://formulae.brew.sh/formula/git-delta | none |

#### Cloud/infra CLIs

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| brew | awscli | /Users/tabuchid/Development/dotfiles/Brewfile:11 | N/A | yes | `aws configure` or `aws configure sso`; verify STS call | ok | /Users/tabuchid/Development/dotfiles/Brewfile:11 | https://formulae.brew.sh/formula/awscli; https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html | none |
| brew | heroku | /Users/tabuchid/Development/dotfiles/Brewfile:57 | N/A | yes | `heroku login` | ok | /Users/tabuchid/Development/dotfiles/Brewfile:57 | https://formulae.brew.sh/formula/heroku; https://devcenter.heroku.com/articles/heroku-cli | none |
| brew | kubernetes-cli | /Users/tabuchid/Development/dotfiles/Brewfile:73 | N/A | yes | Provide kubeconfig; verify `kubectl config get-contexts` | ok | /Users/tabuchid/Development/dotfiles/Brewfile:73 | https://formulae.brew.sh/formula/kubernetes-cli; https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/ | none |
| brew | tilt-dev/tap/tilt | /Users/tabuchid/Development/dotfiles/Brewfile:123 | N/A | yes | Verify `tilt version`; requires local k8s context for use | ok | /Users/tabuchid/Development/dotfiles/Brewfile:123 | https://formulae.brew.sh/formula/tilt; https://docs.tilt.dev/install.html | none |

#### Databases/services

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| brew | libpq | /Users/tabuchid/Development/dotfiles/Brewfile:77 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:77 | https://formulae.brew.sh/formula/libpq | none |
| brew | postgresql@15 | /Users/tabuchid/Development/dotfiles/Brewfile:93 | Homebrew-managed service data/config | yes | Start/verify with `brew services` + `pg_isready` | ok | /Users/tabuchid/Development/dotfiles/Brewfile:93 | https://formulae.brew.sh/formula/postgresql@15 | none |
| brew | rabbitmq | /Users/tabuchid/Development/dotfiles/Brewfile:95 | Homebrew-managed service data/config | yes | Start/verify with `brew services` + `rabbitmq-diagnostics status` | ok | /Users/tabuchid/Development/dotfiles/Brewfile:95 | https://formulae.brew.sh/formula/rabbitmq; https://www.rabbitmq.com/docs/install-homebrew | none |
| brew | redis | /Users/tabuchid/Development/dotfiles/Brewfile:97 | Homebrew-managed service data/config | yes | Start/verify with `brew services` + `redis-cli ping` | ok | /Users/tabuchid/Development/dotfiles/Brewfile:97 | https://formulae.brew.sh/formula/redis | none |

#### Build/toolchains

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| brew | cmake | /Users/tabuchid/Development/dotfiles/Brewfile:19 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:19 | https://formulae.brew.sh/formula/cmake | none |
| brew | gcc | /Users/tabuchid/Development/dotfiles/Brewfile:33 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:33 | https://formulae.brew.sh/formula/gcc | none |
| brew | open-mpi | /Users/tabuchid/Development/dotfiles/Brewfile:35 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:35 | https://formulae.brew.sh/formula/open-mpi | none |
| brew | pkgconf | /Users/tabuchid/Development/dotfiles/Brewfile:55 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:55 | https://formulae.brew.sh/formula/pkgconf | none |

#### Language runtimes

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| brew | erlang | /Users/tabuchid/Development/dotfiles/Brewfile:27 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:27 | https://formulae.brew.sh/formula/erlang | none |
| brew | python@3.12 | /Users/tabuchid/Development/dotfiles/Brewfile:61 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:61 | https://formulae.brew.sh/formula/python@3.12 | none |
| brew | yarn | /Users/tabuchid/Development/dotfiles/Brewfile:115 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:115 | https://formulae.brew.sh/formula/yarn | none |

#### Terminal/editor support

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| brew | ispell | /Users/tabuchid/Development/dotfiles/Brewfile:67 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:67 | https://formulae.brew.sh/formula/ispell | none |
| brew | libgccjit | /Users/tabuchid/Development/dotfiles/Brewfile:75 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:75 | https://formulae.brew.sh/formula/libgccjit | none |
| brew | libvterm | /Users/tabuchid/Development/dotfiles/Brewfile:81 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:81 | https://formulae.brew.sh/formula/libvterm | none |
| brew | tmux | /Users/tabuchid/Development/dotfiles/Brewfile:87 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:87 | https://formulae.brew.sh/formula/tmux | none |
| brew | d12frosted/emacs-plus/emacs-plus@30 | /Users/tabuchid/Development/dotfiles/Brewfile:121 | ~/.config/emacs-plus; /Applications/Emacs.app aliases (best effort) | yes | Patch config linked before `brew bundle`; verify Emacs.app alias if desired | ok | /Users/tabuchid/Development/dotfiles/Brewfile:121; /Users/tabuchid/Development/dotfiles/scripts/setup.sh:59; /Users/tabuchid/Development/dotfiles/scripts/setup.sh:82 | https://formulae.brew.sh/formula/emacs-plus@30; https://github.com/d12frosted/homebrew-emacs-plus | none |

#### Media/OCR/image/PDF

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| brew | giflib | /Users/tabuchid/Development/dotfiles/Brewfile:5 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:5 | https://formulae.brew.sh/formula/giflib | none |
| brew | libpng | /Users/tabuchid/Development/dotfiles/Brewfile:7 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:7 | https://formulae.brew.sh/formula/libpng | none |
| brew | harfbuzz | /Users/tabuchid/Development/dotfiles/Brewfile:45 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:45 | https://formulae.brew.sh/formula/harfbuzz | none |
| brew | tesseract | /Users/tabuchid/Development/dotfiles/Brewfile:47 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:47 | https://formulae.brew.sh/formula/tesseract | none |
| brew | shared-mime-info | /Users/tabuchid/Development/dotfiles/Brewfile:63 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:63 | https://formulae.brew.sh/formula/shared-mime-info | none |
| brew | imagemagick | /Users/tabuchid/Development/dotfiles/Brewfile:65 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:65 | https://formulae.brew.sh/formula/imagemagick | none |
| brew | jpeg | /Users/tabuchid/Development/dotfiles/Brewfile:69 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:69 | https://formulae.brew.sh/formula/jpeg | none |
| brew | librsvg | /Users/tabuchid/Development/dotfiles/Brewfile:79 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:79 | https://formulae.brew.sh/formula/librsvg | none |
| brew | poppler | /Users/tabuchid/Development/dotfiles/Brewfile:91 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:91 | https://formulae.brew.sh/formula/poppler | none |
| brew | vips | /Users/tabuchid/Development/dotfiles/Brewfile:111 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:111 | https://formulae.brew.sh/formula/vips | none |

#### Utilities

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| brew | glib | /Users/tabuchid/Development/dotfiles/Brewfile:15 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:15 | https://formulae.brew.sh/formula/glib | none |
| brew | pixman | /Users/tabuchid/Development/dotfiles/Brewfile:17 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:17 | https://formulae.brew.sh/formula/pixman | none |
| brew | cryptography | /Users/tabuchid/Development/dotfiles/Brewfile:23 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:23 | https://formulae.brew.sh/formula/cryptography | none |
| brew | extract_url | /Users/tabuchid/Development/dotfiles/Brewfile:29 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:29 | https://formulae.brew.sh/formula/extract_url | none |
| brew | fpp | /Users/tabuchid/Development/dotfiles/Brewfile:37 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:37 | https://formulae.brew.sh/formula/fpp | none |
| brew | gnupg | /Users/tabuchid/Development/dotfiles/Brewfile:53 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:53 | https://formulae.brew.sh/formula/gnupg | none |
| brew | libyaml | /Users/tabuchid/Development/dotfiles/Brewfile:83 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:83 | https://formulae.brew.sh/formula/libyaml | none |
| brew | overmind | /Users/tabuchid/Development/dotfiles/Brewfile:89 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:89 | https://formulae.brew.sh/formula/overmind | none |

### Homebrew Casks

#### Cloud/infra CLIs

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| cask | 1password-cli | /Users/tabuchid/Development/dotfiles/Brewfile:125 | N/A | yes | Requires desktop app/sign-in; run `op signin` as needed | ok | /Users/tabuchid/Development/dotfiles/Brewfile:125 | https://formulae.brew.sh/cask/1password-cli; https://developer.1password.com/docs/cli/get-started/ | none |
| cask | ngrok | /Users/tabuchid/Development/dotfiles/Brewfile:134 | N/A | yes | `ngrok config add-authtoken <token>` | ok | /Users/tabuchid/Development/dotfiles/Brewfile:134 | https://formulae.brew.sh/cask/ngrok; https://ngrok.com/docs/getting-started | none |
| cask | session-manager-plugin | /Users/tabuchid/Development/dotfiles/Brewfile:136 | N/A | yes | Verify binary available for AWS SSM workflows | ok | /Users/tabuchid/Development/dotfiles/Brewfile:136 | https://formulae.brew.sh/cask/session-manager-plugin; https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html | none |

#### Fonts

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| cask | font-fira-code | /Users/tabuchid/Development/dotfiles/Brewfile:126 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:126 | https://formulae.brew.sh/cask/font-fira-code | none |
| cask | font-hack-nerd-font | /Users/tabuchid/Development/dotfiles/Brewfile:127 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:127 | https://formulae.brew.sh/cask/font-hack-nerd-font | none |
| cask | font-roboto | /Users/tabuchid/Development/dotfiles/Brewfile:128 | N/A | no | - | ok | /Users/tabuchid/Development/dotfiles/Brewfile:128 | https://formulae.brew.sh/cask/font-roboto | none |

#### Desktop apps

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| cask | wezterm | /Users/tabuchid/Development/dotfiles/Brewfile:130 | ~/.config/wezterm/wezterm.lua | yes | Launch app; verify `~/.config/wezterm/wezterm.lua` is read | ok | /Users/tabuchid/Development/dotfiles/Brewfile:130; /Users/tabuchid/Development/dotfiles/scripts/link.sh:51; /Users/tabuchid/Development/dotfiles/scripts/sync-from-home.sh:84 | https://formulae.brew.sh/cask/wezterm; https://wezterm.org/install/macos.html; https://wezterm.org/config/files.html | none |
| cask | jordanbaird-ice | /Users/tabuchid/Development/dotfiles/Brewfile:132 | N/A | yes | Grant macOS permissions if prompted | ok | /Users/tabuchid/Development/dotfiles/Brewfile:132 | https://formulae.brew.sh/cask/jordanbaird-ice | none |
| cask | spotify | /Users/tabuchid/Development/dotfiles/Brewfile:138 | N/A | yes | Sign in manually | ok | /Users/tabuchid/Development/dotfiles/Brewfile:138 | https://formulae.brew.sh/cask/spotify | none |

### VS Code Extensions

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| vscode_extension | anysphere.cursorpyright | /Users/tabuchid/Development/dotfiles/Brewfile:139 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:139; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=anysphere.cursorpyright | Purpose: Python type checking (CursorPyright) |
| vscode_extension | bierner.markdown-mermaid | /Users/tabuchid/Development/dotfiles/Brewfile:140 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:140; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid | Purpose: Mermaid diagram previews |
| vscode_extension | catppuccin.catppuccin-vsc | /Users/tabuchid/Development/dotfiles/Brewfile:141 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:141; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=catppuccin.catppuccin-vsc | Purpose: Theme |
| vscode_extension | charliermarsh.ruff | /Users/tabuchid/Development/dotfiles/Brewfile:142 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:142; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff | Purpose: Python lint/format integration |
| vscode_extension | datadog.datadog-vscode | /Users/tabuchid/Development/dotfiles/Brewfile:143 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:143; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=datadog.datadog-vscode | Purpose: Datadog integration |
| vscode_extension | esbenp.prettier-vscode | /Users/tabuchid/Development/dotfiles/Brewfile:144 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:144; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode | Purpose: Prettier formatter |
| vscode_extension | github.vscode-github-actions | /Users/tabuchid/Development/dotfiles/Brewfile:145 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:145; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=github.vscode-github-actions | Purpose: GitHub Actions support |
| vscode_extension | mcaragheorghe.vim-enhanced | /Users/tabuchid/Development/dotfiles/Brewfile:146 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:146; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=mcaragheorghe.vim-enhanced | Purpose: Vim workflow helpers |
| vscode_extension | mechatroner.rainbow-csv | /Users/tabuchid/Development/dotfiles/Brewfile:147 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:147; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=mechatroner.rainbow-csv | Purpose: CSV/TSV highlighting |
| vscode_extension | ms-azuretools.vscode-containers | /Users/tabuchid/Development/dotfiles/Brewfile:148 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:148; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers | Purpose: Container tools |
| vscode_extension | ms-azuretools.vscode-docker | /Users/tabuchid/Development/dotfiles/Brewfile:149 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:149; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker | Purpose: Docker tools |
| vscode_extension | ms-python.debugpy | /Users/tabuchid/Development/dotfiles/Brewfile:150 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:150; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=ms-python.debugpy | Purpose: Python debugger backend |
| vscode_extension | ms-python.python | /Users/tabuchid/Development/dotfiles/Brewfile:151 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:151; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=ms-python.python | Purpose: Python extension |
| vscode_extension | ms-vscode.makefile-tools | /Users/tabuchid/Development/dotfiles/Brewfile:152 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:152; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=ms-vscode.makefile-tools | Purpose: Makefile integration |
| vscode_extension | shopify.ruby-lsp | /Users/tabuchid/Development/dotfiles/Brewfile:153 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:153; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=shopify.ruby-lsp | Purpose: Ruby language server |
| vscode_extension | vscodevim.vim | /Users/tabuchid/Development/dotfiles/Brewfile:154 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:154; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=vscodevim.vim | Purpose: Vim emulation |
| vscode_extension | waderyan.gitblame | /Users/tabuchid/Development/dotfiles/Brewfile:155 | ~/Library/Application Support/Code/User; ~/Library/Application Support/Cursor/User | yes | Install VS Code/Cursor apps if using sync/restore workflow | ok | /Users/tabuchid/Development/dotfiles/Brewfile:155; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43 | https://marketplace.visualstudio.com/items?itemName=waderyan.gitblame | Purpose: Inline git blame |

### Configured but Not Installed by Brewfile

| item_type | item_name | installed_by | config_path | requires_post_install_setup | required_setup_steps | status | evidence_local | sources | recommended_change |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| manual_tool | mise | manual install (tracked config only) | ~/.config/mise | yes | Manual install; verify zsh activation | intentional_out_of_band | /Users/tabuchid/Development/dotfiles/scripts/link.sh:50; /Users/tabuchid/Development/dotfiles/scripts/sync-from-home.sh:83; /Users/tabuchid/Development/dotfiles/docs/installs.md:210 | https://mise.jdx.dev/ | none |
| manual_app | Raycast | manual app (sync/link intentionally disabled) | App-managed | yes | Manual install/sign-in if used | intentional_out_of_band | /Users/tabuchid/Development/dotfiles/README.md:69; /Users/tabuchid/Development/dotfiles/docs/installs.md:211 | https://www.raycast.com/ | none |
| manual_app | Visual Studio Code | manual app for editor sync workflow | /Applications/Visual Studio Code.app; ~/Library/Application Support/Code/User | yes | Install app if using editor sync/restore workflow | intentional_out_of_band | /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:29; /Users/tabuchid/Development/dotfiles/docs/installs.md:212 | https://code.visualstudio.com/ | none |
| manual_app | Cursor | manual app for editor sync workflow | /Applications/Cursor.app; ~/Library/Application Support/Cursor/User | yes | Install app if using editor sync/restore workflow | intentional_out_of_band | /Users/tabuchid/Development/dotfiles/scripts/sync-editors.sh:43; /Users/tabuchid/Development/dotfiles/docs/installs.md:213 | https://www.cursor.com/ | none |

## Setup-Sensitive Deep Dives

1. **1Password SSH Agent**
- Install method: manual desktop app install + README prerequisite steps. Config path: `~/.ssh/config` (`IdentityAgent ~/.1password/agent.sock`). Manual steps: enable SSH agent in 1Password, add key, verify `ssh -T git@github.com`. Validation: `ssh -T git@github.com`. Caveat: remote SSH sessions still require local biometric approval unless using client-side agent forwarding.
2. **1Password CLI (`op`)**
- Install method: `Brewfile` cask (`1password-cli`). Config path: app-integrated auth/session, no repo-tracked auth state. Manual steps: sign in to 1Password desktop app; run `op signin` as needed. Validation: `op --version`, `op whoami` (after sign-in). Caveat: depends on desktop app session for smooth auth flow.
3. **Doom Emacs**
- Install method: `/Users/tabuchid/Development/dotfiles/scripts/install-doom.sh`. Config path: `~/.config/emacs` checkout and `~/.config/doom` config. Manual steps: none beyond `./scripts/setup.sh`; script runs `doom install` on fresh installs and `doom upgrade` on reruns. Validation: `~/.config/emacs/bin/doom doctor`. Caveat: legacy `~/.doom.d` is only migrated when present and XDG config is absent.
4. **`emacs-plus@30`**
- Install method: `Brewfile` formula `d12frosted/emacs-plus/emacs-plus@30`. Config path: `~/.config/emacs-plus/build.yml` (linked before `brew bundle`). Manual steps: optional app alias verification in `/Applications`. Validation: `brew list --versions emacs-plus@30`. Caveat: app alias creation is best-effort and non-fatal in `setup.sh`.
5. **zsh-quickstart-kit**
- Install method: `/Users/tabuchid/Development/dotfiles/scripts/install-zsh-quickstart.sh`. Config path: `~/zsh-quickstart-kit`, `~/.zshrc` symlink, repo-linked `~/.zshrc.d`. Manual steps: open a new terminal session after setup. Validation: `readlink ~/.zshrc` and shell startup behavior. Caveat: depends on `zgenom` (now handled by the same script).
6. **zgenom**
- Install method: `/Users/tabuchid/Development/dotfiles/scripts/install-zsh-quickstart.sh` clone/update. Config path: `~/.zgenom`. Manual steps: none if script runs. Validation: `test -d ~/.zgenom/.git`. Caveat: non-git existing directories are backed up before cloning.
7. **Oh My Tmux**
- Install method: `/Users/tabuchid/Development/dotfiles/scripts/install-oh-my-tmux.sh`. Config path: `~/.tmux`, `~/.tmux.conf`, repo `~/.tmux.conf.local`. Manual steps: none beyond bootstrap. Validation: `readlink ~/.tmux.conf`, `tmux -V`. Caveat: clone uses `--single-branch` and updates are `git pull --ff-only`.
8. **WezTerm**
- Install method: `Brewfile` cask. Config path: `~/.config/wezterm/wezterm.lua` (tracked). Manual steps: launch app and confirm config loads. Validation: start WezTerm and verify font/size from tracked config. Caveat: now the only managed terminal (Ghostty removed).
9. **`gh`**
- Install method: `Brewfile` formula. Config path: safe subset tracked at `~/.config/gh/config.yml`; auth state `hosts.yml` intentionally untracked. Manual steps: `gh auth login`. Validation: `gh auth status`. Caveat: keep `~/.config/gh/hosts.yml` untracked.
10. **`awscli`**
- Install method: `Brewfile` formula. Config path: standard AWS config/credentials outside repo. Manual steps: `aws configure` or `aws configure sso`. Validation: `aws sts get-caller-identity`. Caveat: credentials must not be stored in repo.
11. **`session-manager-plugin`**
- Install method: `Brewfile` cask. Config path: none in repo. Manual steps: usually none beyond AWS CLI config and IAM permissions. Validation: ensure `session-manager-plugin` binary is present and test an SSM session. Caveat: depends on AWS credentials and SSM access.
12. **`kubernetes-cli` (`kubectl`)**
- Install method: `Brewfile` formula. Config path: `~/.kube/config` (not tracked). Manual steps: provide kubeconfig/context. Validation: `kubectl config get-contexts`, `kubectl version --client`. Caveat: cluster credentials are intentionally out-of-band.
13. **`tilt`**
- Install method: `Brewfile` formula via `tilt-dev/tap`. Config path: project-local `Tiltfile`s. Manual steps: ensure local Kubernetes context exists. Validation: `tilt version`. Caveat: useful only with a configured cluster/context.
14. **`heroku`**
- Install method: `Brewfile` formula. Config path: auth/session outside repo. Manual steps: `heroku login`. Validation: `heroku auth:whoami` or `heroku apps`. Caveat: auth remains manual.
15. **`ngrok`**
- Install method: `Brewfile` cask. Config path: `~/.config/ngrok` (not tracked). Manual steps: `ngrok config add-authtoken <token>`. Validation: `ngrok version` and a test tunnel. Caveat: auth token must never be tracked.
16. **`fzf`**
- Install method: `Brewfile` formula. Config path: shell integration via zsh framework/config. Manual steps: verify shell integration after opening a new terminal. Validation: `fzf --version` and keybinding/completion behavior. Caveat: repo relies on shell config rather than `fzf --install`.
17. **`zoxide`**
- Install method: `Brewfile` formula. Config path: shell integration in zsh startup. Manual steps: none if zsh config loads. Validation: `zoxide --version`, `zoxide query`. Caveat: activation depends on shell startup correctness.
18. **`postgresql@15`**
- Install method: `Brewfile` formula. Config path: Homebrew-managed service data/config. Manual steps: start service if needed. Validation: `brew services start postgresql@15`, `pg_isready`, `psql`. Caveat: first-install caveats vary by local Homebrew state.
19. **`redis`**
- Install method: `Brewfile` formula. Config path: Homebrew-managed service data/config. Manual steps: start service if needed. Validation: `brew services start redis`, `redis-cli ping`. Caveat: no repo-level config overrides are tracked.
20. **`rabbitmq`**
- Install method: `Brewfile` formula. Config path: Homebrew-managed service data/config. Manual steps: start service; optional plugin/admin setup. Validation: `brew services start rabbitmq`, `rabbitmq-diagnostics status`. Caveat: management plugin/user setup is environment-specific and manual.

## Post-Install Setup Checklist

1. Run `./scripts/setup.sh`.
1. Run `gh auth login` and verify with `gh auth status`.
1. Configure AWS if needed (`aws configure` or `aws configure sso`).
1. Verify `session-manager-plugin` if you use AWS SSM sessions.
1. Install VS Code/Cursor apps if you want editor sync/restore workflows.
1. Open WezTerm and confirm `~/.config/wezterm/wezterm.lua` is applied.
1. Run `~/.config/emacs/bin/doom doctor`.
1. Open a new terminal and verify zsh startup, plugins, `fzf`, `zoxide`, and `uv` shell behavior.
1. Start and verify only the local services you need (`postgresql@15`, `redis`, `rabbitmq`).
1. Optional local cleanup if `brew doctor` warns: `brew link pkgconf`.

## Residual Risks / Open Items

1. `brew bundle check` can still report missing dependencies on a given machine until `brew bundle install` / `./scripts/setup.sh` is run.
2. End-to-end runtime validation after the repo changes is still machine-specific and may remain pending (Doom health, WezTerm launch/config, zsh/tmux behavior, service startup).
3. The Raycast cleanup deletion set was intentionally large (generated state removal); review before commit if not already committed.

## Sources

All per-item URLs are embedded in the `sources` column in the audit matrix above.

Primary synthesis sources used for setup-sensitive validation:
- https://docs.brew.sh/Brew-Bundle-and-Brewfile
- https://developer.1password.com/docs/ssh/agent/
- https://developer.1password.com/docs/cli/get-started/
- https://github.com/doomemacs/doomemacs
- https://github.com/d12frosted/homebrew-emacs-plus
- https://github.com/unixorn/zsh-quickstart-kit
- https://github.com/jandamm/zgenom
- https://github.com/gpakosz/.tmux
- https://wezterm.org/install/macos.html
- https://wezterm.org/config/files.html
- https://cli.github.com/manual/gh_auth_login
- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
- https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
- https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/
- https://docs.tilt.dev/install.html
- https://devcenter.heroku.com/articles/heroku-cli
- https://ngrok.com/docs/getting-started
- https://github.com/junegunn/fzf
- https://github.com/ajeetdsouza/zoxide
- https://www.rabbitmq.com/docs/install-homebrew

## Audit Coverage Summary

- Taps: `3`
- Formulae: `60`
- Casks: `9`
- VS Code extensions: `17`
- Script-managed installs: `4`
- Manual prerequisites: `3`
- Configured but not installed by Brewfile: `4`
- Total matrix rows (excluding header/category separators): `100`
