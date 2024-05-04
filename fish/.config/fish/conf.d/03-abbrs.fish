abbr n nvim
abbr el "eza -al"
abbr elt "eza -alT"
abbr mv "mv -i"
abbr lg lazygit
abbr gl "git log --oneline --graph"
abbr gs "git status"
abbr qq exit
abbr tn "tmux new -s (pwd | sed 's/.*\///g')"
abbr ta "tmux attach"
abbr td "tmux detach"
abbr ma "mamba activate"
abbr md "mamba deactivate"
abbr m mamba
if test $IS_TMUX -eq 1
    abbr :q "tmux detach"
else
    abbr :q exit
end
