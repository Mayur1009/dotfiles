function auto_activate_mamba -d "Auto activate mamba environment (in .venv file) on directory change" --on-variable PWD --on-variable IS_TMUX
    if test -f "$PWD/.venv"
        set -l venv (cat $PWD/.venv)

        # Check if a environment is already activated.
        if set -q CONDA_DEFAULT_ENV
            if test "$CONDA_DEFAULT_ENV" = "$venv"
                echo "auto_activate_mamba: Environment $venv already activated."
            else
                echo "auto_activate_mamba: Already active environment $CONDA_DEFAULT_ENV. Aborting..."
            end
            return
        end

        # If the environment is not valid, abort.
        if not contains "$venv" (mamba env list | tail -n +3 | awk '{print $1}')
            echo ".venv: Environment not found. Fix the name of environment in .venv file. Aborting..."
            return
        end

        # Activate the environment.
        echo "auto_activate_mamba: Activating environment $venv"
        mamba activate "$venv"
    end
end
