if status is-interactive
    # Commands to run in interactive sessions can go here
end

# PATH
fish_add_path -aP $HOME/.config/emacs/bin

# Set
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --glob "!.git/*"'
# Virtual fish
set -gx VIRTUALFISH_HOME $HOME/ext/envs
# Libvirt - winapps
set -gx LIBVIRT_DEFAULT_URI "qemu:///system"
# RIP
set -gx GRAVEYARD $HOME/.graveyard

abbr n nvim
abbr qq exit
abbr el "exa -al"
abbr elt "exa -alT"
abbr mv "mv -i"
abbr lg lazygit
abbr gopt "g++ -std=c++17 -Wshadow -Wall -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG -g"

function compg -d "Compile .cpp with options" -a file
    g++ -std=c++17 -Wshadow -Wall -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG -g -o $(basename $file .cpp) $file
    printf '%s' "Compiled $file -> $(basename $file .cpp)"
end

# Created by `pipx` on 2023-06-27 07:19:47
set PATH $PATH $HOME/.local/bin

# Starship
starship init fish | source

# Zoxide
zoxide init fish | source


# fzf.fish
fzf_configure_bindings --directory=\cf
set fzf_fd_opts --hidden --exclude=.git
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set fzf_directory_opts --bind ctrl-h:toggle-preview

# Tmux session management and abbrs
fish_add_path -aP $HOME/.tmux/plugins/t-smart-tmux-session-manager/bin
abbr tn "tmux new -s (pwd | sed 's/.*\///g')"
abbr ta "tmux attach"
abbr td "tmux detach"
