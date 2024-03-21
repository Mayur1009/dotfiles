if status is-interactive
    # Commands to run in interactive sessions can go here
end

switch (uname)
    case Linux
        echo "fish: Loading Linux config..."

        # Libvirt - winapps
        set -gx LIBVIRT_DEFAULT_URI "qemu:///system"
        # RIP
        set -gx GRAVEYARD $HOME/.graveyard
        # Virtual fish
        set -gx VIRTUALFISH_HOME $HOME/ext/envs

        function dbgconsole --wraps='qdbus org.kde.KWin /KWin org.kde.KWin.showDebugConsole' --description 'alias dbgconsole=qdbus org.kde.KWin /KWin org.kde.KWin.showDebugConsole'
            qdbus org.kde.KWin /KWin org.kde.KWin.showDebugConsole $argv;
        end

    case Darwin
        echo "fish: Loading MacOS config..."

        eval "$(/opt/homebrew/bin/brew shellenv)"

        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        if test -f $HOME/miniforge3/bin/conda
            eval $HOME/miniforge3/bin/conda "shell.fish" "hook" $argv | source
        else
            if test -f "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
                . "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
            else
                # set -x PATH "$HOME/miniforge3/bin" $PATH
                fish_add_path -gP $HOME/miniforge3/bin
            end
        end

        if test -f "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
            source "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
        end
        # <<< conda initialize <<<

        fish_add_path -gaP $HOME/.local/bin
end

# Theme
source $HOME/.config/fish/carbonfox.fish

# Starship
starship init fish | source

set -gx EDITOR nvim
if test -n "$TMUX"
    set -gx IS_TMUX 1
else
    set -gx IS_TMUX 0
end

# ABBR
abbr n nvim
abbr el "eza -al"
abbr elt "eza -alT"
abbr mv "mv -i"
abbr lg lazygit
abbr :q exit
abbr tn "tmux new -s (pwd | sed 's/.*\///g')"
abbr ta "tmux attach"
abbr td "tmux detach"
if test $IS_TMUX -eq 1
    abbr qq "tmux detach"
else
    abbr qq exit
end
abbr ma "mamba activate"
abbr md "mamba deactivate"
abbr m "mamba"

# fish reload
function fish-reload -d "Reload the shell"
    source $HOME/.config/fish/config.fish
end

# t
function t -d "Create or connect to session from fzf"
    if test -f $HOME/.scripts/t
        $HOME/.scripts/t
    else 
        echo "t: script not found"
    end
end

