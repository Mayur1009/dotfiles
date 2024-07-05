# t
function t -d "Create or connect to session using fzf"
    if set -q TMUX
        echo "Use tmux keybind...(C-a f)"
        return
    end

    set -l selected $argv[1]

    if test -z "$selected"
        set selected (begin 
            tmux list-sessions 2>/dev/null | awk -F: '{print $1}'
            fd -H -t d -L -i --ignore-file ~/.my_fdignore . ~ 
        end | fzf)
    end

    if test -z "$selected"
        echo "Nothing selected"
        return
    end

    set -l sname (basename $selected | tr . _)

    if not tmux has -t=$sname 2>/dev/null
        tmux new -s "$sname" -n "nvim" -c $selected -d \; send-keys -t "$sname:nvim.1" nvim C-m
        # tmux send-keys -t $sname nvim Enter
    end

    tmux attach -t $sname
end
