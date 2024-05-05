# t
function t -d "Create or connect to session using fzf"

    if set -q TMUX
        echo "Use tmux keybind...(C-a f)"
        return
    end

    set -l selected (begin 
        tmux list-sessions 2>/dev/null | awk -F: '{print $1}'
        fd -H -t d -L -i . ~ 
    end | fzf)

    if test -z "$selected"
        echo "Nothing selected"
        return
    end

    set -l sname (basename $selected | tr . _)

    if not tmux has -t=$sname 2>/dev/null
        tmux new -s "$sname" -c $selected -d \; send-keys -t "$sname:1.1" nvim C-m
        # tmux send-keys -t $sname nvim Enter
    end

    tmux attach -t $sname
end
