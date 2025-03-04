# Activate local Python venv
function activate
    # Set path to venv activation script
    set target -f "./.venv/bin/activate.fish"

    # create venv if it doesn't exist
    if not test -e $target
        python -m venv ./.venv
    end

    # activate venv
    source $target
end
