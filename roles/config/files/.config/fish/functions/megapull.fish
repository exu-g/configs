# Pull all git repos within the current directory
function megapull
    find . -type d -exec sh -c 'if [ -d "$0/.git" ]; then git -C "$0" pull; fi' {} \;
end
