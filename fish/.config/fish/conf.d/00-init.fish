switch (uname)
    case Linux
        echo "fish: Loading Linux config..."

        function dbgconsole --wraps='qdbus org.kde.KWin /KWin org.kde.KWin.showDebugConsole' --description 'alias dbgconsole=qdbus org.kde.KWin /KWin org.kde.KWin.showDebugConsole'
            qdbus org.kde.KWin /KWin org.kde.KWin.showDebugConsole $argv
        end

    case Darwin
        echo "fish: Loading MacOS config..."
        eval "$(/opt/homebrew/bin/brew shellenv)"
end
