# t
function t -d "Create or connect to session using fzf"
    set selected (fzf --tmux --height=50% --walker=dir,follow,hidden --walker-root="$HOME" --walker-skip=Library,.Trash,miniforge3,.cache,.git,node_modules,.venv,.nvim_venv,Pictures,Music,Applications,Movies,Public,.vscode,.ssh,.npm,go,.cargo)

    if test -z "$selected"
        echo "Nothing selected"
        return
    end

    set -l sname (basename $selected | tr . _)

    if not tmux has -t=$sname 2>/dev/null
        tmux new -s "$sname" -n nvim -c "$selected" -d \; send-keys -t "$sname:nvim.1" nvim C-m
    end

    if set -q TMUX
        tmux switch -t $sname
    else
        tmux attach -t $sname
    end
end
