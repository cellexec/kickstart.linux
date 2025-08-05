# Go
export PATH="$(go env GOPATH)/bin:$PATH"
export GITLAB_HOST="https://gitlab.lit-beratung.de"

# Rust
. "$HOME/.cargo/env"

export TERM=xterm-256color
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Enable Powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load plugin manager (zinit)
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Reload the zinit
source "${ZINIT_HOME}/zinit.zsh"

# Install plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light jeffreytse/zsh-vi-mode

# Autoload completions
autoload -U compinit && compinit

# History settings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# Options
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Colors for completions
zstyle ':completions:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completions:*' list-colors '${(s.:.)LS_COLORS}'

# Source powerlevel 10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



################
# User section
################

# Extend Path variables
export PATH="$PATH:$HOME/projects/kickstart.linux/bin/"
export PATH="$PATH:$HOME/projects/kickstart.linux/bin/nvim/bin"
export PATH="$PATH:$HOME/projects/kickstart.linux/bin/flux/"
export PATH="$PATH:$HOME/projects/kickstart.linux/bin/fzf/"
export PATH="$PATH:$HOME/projects/kickstart.linux/bin/k9s/"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/usr/sbin"
export PATH="$PATH:/usr/bin"
export PATH="$PATH:/sbin"
export PATH="$PATH:/bin"

export VISUAL=nvim
export EDITOR="$VISUAL"


# Program alias
alias fr="flux reconcile kustomization flux-system -n flux-system --with-source"
alias ee="exit"
alias k="kubectl"
alias gl="git log --decorate --oneline --graph"
alias ls="ls --color"
alias ll="ls -la"
alias vim="nvim"
alias ta="tmux attach"
alias tk="tmux kill-session"
alias tl="tmux list-session"
alias ldk='lazydocker'

# Command alias
alias gacp="[ -d .git ] && git add . && git commit && git pull && git push"
alias gacpl="[ -d .git ] && git add . && git commit -m 'update' && git pull && git push"
alias gacpp="[ -d .git ] && git add . && git commit -m 'update Lazy Plugins' && git pull && git push"
alias n='jq -r ".scripts | keys[]" package.json | fzf --prompt="Select a script: " | xargs -r npm run'
alias reload="source ~/.zshrc"
alias stop_all_docker='docker ps -aq | xargs docker stop'
alias vaults='cd $(find ~/vaults/ -maxdepth 1 -mindepth 1 -type d | sed "s|^\./||" | fzf) && vim'


# Fzf (Fuzzy Finder)
export FZF_DEFAULT_OPTS='--layout=reverse --border --preview-window=wrap --height=40%'
eval "$(fzf --zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

unalias s 2>/dev/null

s() {
    if [ $# -eq 0 ]; then
        # Extract host names from SSH config file
        # Remove comments, empty lines, and get only Host lines
        # Exclude wildcards and patterns (lines containing * or ?)
        host=$(grep "^Host " ~/.ssh/config | 
               grep -v "[*?]" | 
               sed 's/Host //' | 
               tr ' ' '\n' | 
               fzf --height 40% --reverse)
        
        if [ -n "$host" ]; then
            # If a host was selected, connect with X11 forwarding
            command ssh -X "$host"
        fi
    else
        # If arguments were provided, pass them through to ssh
        command ssh "$@"
    fi
}

alias s="s"

unalias p 2>/dev/null
p() {
  local dir
  dir=$(find ~/projects/ -maxdepth 1 -type d | fzf)
  if [ -n "$dir" ]; then
    cd "$dir"
  fi
}

alias p="p"
