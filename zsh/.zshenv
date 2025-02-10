typeset -U path PATH

path_add_helper() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        if [ -z "$2" ]; then
            path=($path $1)
        else
            path=($1 $path)
        fi
    fi
}

path_add_helper "$HOME/.local/bin"
path_add_helper "$HOME/go/bin"
path_add_helper "$HOME/zig"

# path=($path $HOME/.local/bin $HOME/go/bin)
# if [ -d "$HOME/zig" ]; then
#     path+=($HOME/zig)
# fi
# if [ -d "$HOME/.pixi/bin" ]; then
#     path+=($HOME/.pixi/bin)
# fi
export PATH

export EDITOR="nvim"
export VISUAL="nvim"

. "$HOME/.cargo/env"

