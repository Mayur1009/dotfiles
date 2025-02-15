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
path_add_helper "$HOME/.fzf/bin"
path_add_helper "$HOME/.pixi/bin"
path_add_helper "$HOME/neovim/bin"

export PATH

export EDITOR="nvim"
export VISUAL="nvim"

. "$HOME/.cargo/env"

