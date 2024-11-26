typeset -U path PATH
path=($path $HOME/.local/bin $HOME/go/bin)
export PATH

export EDITOR="nvim"
export VISUAL="nvim"

. "$HOME/.cargo/env"
