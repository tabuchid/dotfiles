#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

eval "$(rbenv init -)"

# Vim Config
export VIMCONFIG=~/.config/nvim
export VIMDATA=~/.local/share/nvim

export EDITOR=nvim
export VISUAL=nvim
# Use Neovim instead of Vim or Vi
alias vim=nvim
alias vi=nvim

export HOMEBREW_GITHUB_API_TOKEN=""
export HOMEBREW_UPGRADE_CLEANUP=1
export GPG_TTY=$(tty)
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export APPLE_ID=doug@percolate.com

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/doug/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/doug/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/doug/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/doug/google-cloud-sdk/completion.zsh.inc'; fi

## Starts recording the simulator.
recsim() {
    xcrun simctl io booted recordVideo "$1"
}

# added by pipsi (https://github.com/mitsuhiko/pipsi)
export PATH="/Users/doug/.local/bin:$PATH"

# Python don't write pyc
export PYTHONDONTWRITEBYTECODE=1
