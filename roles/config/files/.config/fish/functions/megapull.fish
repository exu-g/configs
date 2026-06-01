# Pull all git repos within the current directory
function megapull
    switch $argv[1]
        case main
            find . -type d -exec test -d {}/.git \; -exec echo "Working on {}" \; -exec git -C {} switch main \; -exec git -C {} pull \;
        case master
            find . -type d -exec test -d {}/.git \; -exec echo "Working on {}" \; -exec git -C {} switch master \; -exec git -C {} pull \;
        case help
            echo "Help:"
            echo "- <default>: Recursively find git repos and git pull"
            echo "- master:    Switch to `master` branch and git pull"
            echo "- main:      Switch to `main` branch and git pull"
        case '*'
            find . -type d -exec test -d {}/.git \; -exec echo "Working on {}" \; -exec git -C {} pull \;
    end
end
