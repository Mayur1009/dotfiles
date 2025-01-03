typeset -U path PATH
path=($path $HOME/.local/bin $HOME/go/bin)
if [ -d "$HOME/zig" ]; then
    path+=($HOME/zig)
fi
export PATH

export EDITOR="nvim"
export VISUAL="nvim"

. "$HOME/.cargo/env"
