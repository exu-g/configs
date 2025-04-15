# Pull all git repos within the current directory
function megapull
    find . -type d -exec test -d {}/.git \; -exec echo "Working on {}" \; -exec git -C {} pull \;
end
