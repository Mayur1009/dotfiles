set fish_greeting
# fish_config theme choose "Rosé Pine"

# Are we in TMUX?
if test -n "$TMUX"
    set -gx IS_TMUX 1
else
    set -gx IS_TMUX 0
end

fish_add_path -gaP $HOME/.local/bin

set -gx EDITOR nvim

