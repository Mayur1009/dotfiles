#! /usr/bin/env fish -N

if ! test -n "$(pgrep tmux)"
    echo "tmux not running....starting server"
    tmux start-server
end

set selected (begin 
    tmux list-sessions 2>/dev/null | awk -F: '{print $1}'
    fd -H -t d -L -i . ~ 
end | fzf)

if test -z "$selected"
    echo "Nothing selected"
    exit
end

set sname (basename $selected | tr . _)

if not tmux has -t=$sname 2>/dev/null
    tmux new -s $sname -c $selected -d
    tmux send-keys -t $sname nvim Enter
end

if set -q TMUX
    tmux switch -t $sname
else
    tmux attach -t $sname
end
