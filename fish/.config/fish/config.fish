if status is-interactive
    # Commands to run in interactive sessions can go here
end

# set PATH (string match -v /opt/homebrew/opt/fzf/bin $PATH)
# set PATH (string match -v /Users/mayurks/miniconda3/condabin $PATH)
# set PATH (string match -v /Applications/kitty.app/Contents/MacOS $PATH)
# set PATH (string match -v /Users/mayurks/.local/bin $PATH)

# eval "$(/opt/homebrew/bin/brew shellenv)"

# fish_add_path -mpP "/opt/homebrew/bin" "/opt/homebrew/sbin"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -f /Users/mayurks/miniconda3/bin/conda
#     eval /Users/mayurks/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# else
#     if test -f "/Users/mayurks/miniconda3/etc/fish/conf.d/conda.fish"
#         . "/Users/mayurks/miniconda3/etc/fish/conf.d/conda.fish"
#     else
#         set -x PATH "/Users/mayurks/miniconda3/bin" $PATH
#     end
# end
# <<< conda initialize <<<

# fish_add_path -aP "/Users/mayurks/.local/bin"

# zoxide init fish | source

starship init fish | source

# ABBREVIATIONS and ALIASES
abbr n nvim
abbr el "eza -al"
abbr elt "eza -alT"
abbr mv "mv -i"
abbr lg lazygit
abbr :q exit
abbr kick "NVIM_APPNAME=kickstart nvim"
abbr tn "tmux new -s (pwd | sed 's/.*\///g')"
abbr ta "tmux attach"
abbr td "tmux detach"
if set -q TMUX
    abbr qq "tmux detach"
else
    abbr qq exit
end

# FUNCTIONS
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

function fish -d "Reload the shell"
    source ~/.config/fish/config.fish
end

# Theme
source ~/.config/fish/tokyonight.fish
