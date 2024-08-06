# INIT
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:cd:*' ignore-parents parent pwd

zmodload zsh/complist
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi
autoload -Uz compinit
compinit
bindkey -e

# Starship
eval "$(starship init zsh)"

# fzf
source <(fzf --zsh)

# Mamba
__conda_setup="$('$HOME/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
if [ -f "$HOME/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "$HOME/miniforge3/etc/profile.d/mamba.sh"
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
alias gl="git log --oneline --graph"
alias gs="git status"
alias tn="tmux new -s \$(pwd | sed \"s/.*\\///g\")"
alias ta="tmux attach"
alias td="tmux detach"
alias qq="tmux detach"
alias ma="mamba activate"
alias md="mamba deactivate"

# Auto activate Mamba environment if .mamba found
function auto_activate_mamba() {
    if [[ -f $PWD/.mamba ]]; then
        echo "auto_activate_mamba: .mamba found."
        if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
            echo "auto_activate_mamba: Some Environment was already set."
        fi
        venv=`cat $PWD/.mamba`
        if mamba env list | tail -n +3 | awk '{print $1}' | grep -q "$venv"; then
            mamba activate $venv
        else
            echo "auto_activate_mamba: '$venv' environment does not exist. Aborting..."
        fi
    fi
}
chpwd_functions+=("auto_activate_mamba")
auto_activate_mamba

function t() {
    $HOME/.tmux_session
}

case "$OSTYPE" in
    linux*)
        HISTSIZE=2000
        SAVEHIST=1000
        HISTFILE=~/.histfile
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
        source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ;;
    darwin*)
        source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
        source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ;;
esac
