switch (uname)
    case Linux
        echo "fish: Loading Linux config..."

        # Libvirt - winapps
        set -gx LIBVIRT_DEFAULT_URI "qemu:///system"
        # RIP
        set -gx GRAVEYARD $HOME/.graveyard
        # Virtual fish
        set -gx VIRTUALFISH_HOME $HOME/ext/envs

        function dbgconsole --wraps='qdbus org.kde.KWin /KWin org.kde.KWin.showDebugConsole' --description 'alias dbgconsole=qdbus org.kde.KWin /KWin org.kde.KWin.showDebugConsole'
            qdbus org.kde.KWin /KWin org.kde.KWin.showDebugConsole $argv
        end

        set -gx CUDA_PATH /opt/cuda
        fish_add_path -gP /opt/cuda/bin
        fish_add_path -gP /opt/cuda/nsight_compute
        fish_add_path -gP /opt/cuda/nsight_systems/bin

        # Set the default host compiler for nvcc. This will need to be switched back
        # and forth between the latest and previous GCC version, whatever nvcc
        # currently supports.
        set -gx NVCC_CCBIN '/usr/bin/g++-13'

    case Darwin
        echo "fish: Loading MacOS config..."
        eval "$(/opt/homebrew/bin/brew shellenv)"
end
