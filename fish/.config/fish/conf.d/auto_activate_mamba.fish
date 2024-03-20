function auto_activate_mamba -d "Auto activate mamba environment (in .venv file) on directory change" --on-variable PWD --on-variable IS_TMUX
    if test -f "$PWD/.venv"
        if contains (cat $PWD/.venv) (mamba env list | tail -n +3 | awk '{print $1}')
            echo "auto_activate_mamba: Activating environment $(cat $PWD/.venv)"
            mamba activate (cat $PWD/.venv)
        else 
            echo ".venv: Environment not found. Fix the name of environment in .venv file."
        end
    end
end

