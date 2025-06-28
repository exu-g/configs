# huge update function
function up
    switch $argv[1]
        case help
            echo "Help:"
            echo "-: Update all packages"
            echo "- packages: Update system packages and rebuild necessary AUR packages"
            echo "- flatpak: Update flatpak packages"
            echo "- emacs: Update doom emacs"
        case packages
            up_packages
        case flatpak
            up_flatpak
        case emacs
            up_emacs
        case '*'
            up_packages
            up_flatpak
            up_emacs
    end
end

# system packages
function up_packages
    # update packages
    paru -Syu
    # rebuild AUR packages
    paru -S --rebuild=yes (checkrebuild | awk '{print $2}')
end

function up_flatpak
    flatpak update --assumeyes
end

# doom emacs
function up_emacs
    doom upgrade --aot --jobs (nproc) --force
    doom sync --gc -j (nproc)
end
