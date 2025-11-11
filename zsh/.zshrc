# INIT
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:cd:*' ignore-parents parent pwd
autoload -Uz compinit
compinit
bindkey -e

# Pixi
if command -v pixi &> /dev/null; then
    eval "$(pixi completion --shell zsh)"
fi

# Starship
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# fzf
if command -v fzf &> /dev/null; then
    source <(fzf --zsh)
fi

# Direnv
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# Mise
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
    eval "$(mise completion zsh)"
fi

# Completions
zmodload zsh/complist
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

# If ~/.pixi/completions exists, add it to fpath
if [ -d "$HOME/.pixi/completions" ]; then
    fpath+=("$HOME/.pixi/completions/zsh")
fi


# Alias
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias ls='ls --color=auto'
alias n="nvim"
alias el="eza -al"
alias elt="eza -alT"
alias lg="lazygit"
alias fm="ranger"
alias gl="git log --oneline --graph"
alias gt="git status"
alias tn="tmux new -s \$(pwd | sed \"s/.*\\///g\")"
alias ta="tmux attach"
alias td="tmux detach"
alias qq="tmux detach"
alias ma="mamba activate"
alias md="mamba deactivate"
# alias tmux='direnv exec / tmux'
alias kernel_create="python -m ipykernel install --user --name"
alias cair16="docker -H ssh://cair-gpu16"

alias lz="NVIM_APPNAME=lazy nvim"

function t() {
    $HOME/.tmux_session
}

setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_BEEP

case "$OSTYPE" in
linux*)
    HISTSIZE=100000
    SAVEHIST=100000
    HISTFILE=~/.histfile
    source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source $HOME/.zsh/zsh-history-substring-search.zsh
    source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    ;;
darwin*)
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ;;
esac

