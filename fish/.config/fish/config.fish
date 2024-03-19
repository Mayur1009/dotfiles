if status is-interactive
    # Commands to run in interactive sessions can go here
end

switch (uname)
    case Linux
        echo "Loading Linux config..."

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
        echo "Loading MacOS config..."
end

# Theme
source ~/.config/fish/carbonfox.fish

# Starship
starship init fish | source

# Zoxide
zoxide init fish | source

# Mamba
if test -f "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
    source "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
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
if set -q TMUX
    abbr qq "tmux detach"
else
    abbr qq exit
end
abbr ma "mamba activate"
abbr md "mamba deactivate"
abbr m "mamba"

# Variables
# set -gx EDITOR nvim

# Sesh
function t
    sesh connect $(sesh list -tz | fzf-tmux -p 55%,60% \
    --border-label ' sesh ' --prompt '⚡  ' \
    --header '  ^a all ^t tmux ^x zoxide ^f find ^g find-home' \
    --bind 'tab:down,btab:up' \
    --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list)' \
    --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
    --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z)' \
    --bind 'ctrl-f:change-prompt(🔍  )+reload(fd -H -t d -L -i)' \
    --bind 'ctrl-g:change-prompt(🔍  )+reload(fd -H -t d -L -i --base-directory ~)')
end

# fish reload
function fish-reload -d "Reload the shell"
    source ~/.config/fish/config.fish
end

