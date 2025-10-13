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
path_add_helper "$HOME/.pixi/bin" 1
path_add_helper "$HOME/go/bin"
path_add_helper "$HOME/zig"
path_add_helper "$HOME/texlive/2025/bin/x86_64-linux"
path_add_helper "$HOME/.juliaup/bin" 1

export PATH

export EDITOR="nvim"
export VISUAL="nvim"

. "$HOME/.cargo/env"

