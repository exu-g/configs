function pipup
    switch $argv[1]
        case update
            python -m pip list --outdated --format=json | python -c "import json, sys; print('\n'.join([x['name'] for x in json.load(sys.stdin)]))" | xargs -n1 python -m pip install -U
        case list
            python -m pip list --outdated
        case help
            echo "Help:"
            echo "- update: Updates all installed Python packages"
            echo "- list:   Lists all Python packages that need updates"
        case '*'
            echo "Unknown command: $argv[1]"
            echo "Use `help` to see available commands"
    end
end
