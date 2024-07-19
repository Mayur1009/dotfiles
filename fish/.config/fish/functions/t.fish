# t
function t -d "Create or connect to session using fzf"
    if set -q TMUX
        echo "Use tmux keybind...(C-a f)"
        return
    end

    set selected (fzf --tmux --height=50% --walker=dir,follow,hidden --walker-root="$HOME" --walker-skip=Library,.Trash,miniforge3,.cache,.git,node_modules,.venv)

    if test -z "$selected"
        echo "Nothing selected"
        return
    end

    set -l sname (basename $selected | tr . _)

    if not tmux has -t=$sname 2>/dev/null
        tmux new -s "$sname" -n nvim -c "$selected" -d \; send-keys -t "$sname:nvim.1" nvim C-m
    end

    tmux attach -t $sname
end
