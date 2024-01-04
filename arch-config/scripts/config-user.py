#!/usr/bin/env python3

import argparse
import os
import shutil
import subprocess
import re
import dialog # install pythondialog

def func_seltheme():
    """
    Dialogue to select a theme
    """
    d = dialog.Dialog(dialog="dialog")

    options = ["Nyarch", "Spaceengine Pink"]

    response, selected_index = d.menu("Select theme", choices=options)

    # User selects an option
    if response == 0:
        theme: str = options[selected_index]
        # write theme name defined in `options` to .seltheme
        with open(f"{home_dir}/.seltheme", "w") as file:
            file.write(theme)

def copy_firefox():
    """
    Copy configuration for Firefox
    """
    pass

def main():
    """
    Main function
    """
    global home_dir 
    home_dir = os.environ["HOME"]

    # find temporary directory
    scriptloc = os.path.abspath(__file__)
    tempdir = os.path.dirname(scriptloc)

    # Force theme selection if none has been selected yet
    if not os.path.isfile(os.path.join(home_dir, ".seltheme")):
        func_seltheme()

    print("""\
########################################
################ Backup ################
########################################\
""")

    ####################
    ##### Cleaning #####
    ####################

    # Remove old backup
    old_dat_path = os.path.join(home_dir, "old_dat")
    if os.path.isdir(old_dat_path):
        print("Removing old backup")
        shutil.rmtree(old_dat_path)

    ####################
    ##### Creating #####
    ####################

    # create folders
    print("Creating backup")
    os.makedirs(old_dat_path)
    os.makedirs(os.path.join(old_dat_path, ".config"))
    os.makedirs(os.path.join(old_dat_path, ".doom.d"))
    os.makedirs(os.path.join(old_dat_path, ".mozilla"))
    os.makedirs(os.path.join(old_dat_path, "scripts"))
    os.makedirs(os.path.join(old_dat_path, ".ssh"))
    os.makedirs(os.path.join(old_dat_path, ".local"))
    os.makedirs(os.path.join(old_dat_path, ".local", "share"))

    # backup config folders
    config_folders = ["MangoHud","fish","gtk-3.0","sway","polybar"]

    for folder in config_folders:
        src = os.path.join(home_dir, f".config/{folder}")
        if os.path.isdir(src):
            dst = os.path.join(old_dat_path, ".config")
            shutil.copytree(src, dst)

    # backup main level folders
    other_folders = [".ssh",".mozilla","scripts"]

    for folder in other_folders:
        src = os.path.join(home_dir, folder)
        if os.path.isdir(src):
            shutil.copytree(src, old_dat_path)

    ####################
    ###### Cleanup #####
    ####################

    folders = [".config/Vorlagen","scripts/in_path","scripts/pieces","scripts/polybar","scripts/archive"]
    
    for folder in folders:
        path = os.path.join(home_dir, folder)
        if os.path.isdir(path):
            shutil.rmtree(path)

    print("""\
########################################
########### Copy New Config  ###########
########################################\
""")

    # copy folders
    copy_folders = [".config",".local",".ssh","scripts"]

    for folder in copy_folders:
        path = os.path.join(tempdir, "arch-config", folder)
        shutil.copytree(path, home_dir)

    # copy files
    copy_files = [".face",".gtkrc-2.0",".gitconfig",".kopiaignore",".Xdefaults"]
    
    for file in copy_files:
        path = os.path.join(tempdir, "arch-config", file)
        shutil.copy(path, home_dir)

    # Copy firefox if argument "-f" or "--firefox" is given
    if copy_firefox and os.path.isdir(os.path.join(home_dir, ".mozilla/firefox")):
        firefox_dirs = [dirname for dirname in os.listdir(os.path.join(home_dir,".mozilla/firefox")) if re.search('.*default-release', dirname)]
        if len(firefox_dirs) >= 1:
            for directory in firefox_dirs:
                src = os.path.join(tempdir, "arch-config/.mozilla/firefox/default-release")
                shutil.copytree(src, directory)
        else:
            print("Please launch firefox and then update the config again")
    else:
        print("Please launch firefox and then update the config again")

    print("Copied folder and files")

    print("""\
##############################
##### Per Device Settings ####
##############################\
""")

    # Skipped for now
    # shell commands as reference
    '''
    # lupusregina
    # TODO analyse parts necessary for Wayland with Alita
    if [ "$(hostname)" == "lupusregina" ]; then
        echo "Applying overrides for $(hostname)"
        # polybar dpi
        polybardpi="$(cat ~/configs/arch-config/per-device/lupusregina/polybar-dpi-override.ini)"
        awk -v polybardpi="$polybardpi" '/;per-device dpi insert/{print;print polybardpi;next}1' ~/.config/polybar/i3config.ini >/tmp/i3config.ini
        cp /tmp/i3config.ini ~/.config/polybar/i3config.ini
        # xresources dpi
        xftdpi="$(cat ~/configs/arch-config/per-device/lupusregina/xresources-dpi-override)"
        awk -v xftdpi="$xftdpi" '/!per-device dpi insert/{print;print xftdpi;next}1' ~/.Xdefaults >/tmp/.Xdefaults
        cp /tmp/.Xdefaults ~/.Xdefaults
    fi
    '''

    print("""\
####################
###### Theme  ######
####################\
""")

    # read selected theme
    seltheme = ""
    with open(os.path.join(home_dir, ".seltheme"), "r") as file:
        seltheme = file.read()

    match seltheme:
        case "Nyarch":
            shutil.copy(os.path.join(tempdir, "arch-themes/nyarch/sway/color"), os.path.join(home_dir, ".config/sway/config.d"))
        case "Spaceengine Pink":
            shutil.copy(os.path.join(tempdir, "arch-themes/space-pink/sway/color"), os.path.join(home_dir, ".config/sway/config.d"))
        case _:
            raise ValueError("No theme defined")

    # copy chosen image for lockscreen and desktop
    backgroundimage = "/home/exu/Bilder/Backgrounds/artstation/dk-lan/artstation_14224733_55806391_月半与鬼哭.jpg"

    os.makedirs(os.path.join(home_dir, ".cache"))
    os.makedirs(os.path.join(home_dir, ".cache", "backgrounds"))

    shutil.copy(backgroundimage,os.path.join(home_dir,".cache/backgrounds/desktop"))
    shutil.copy(backgroundimage,os.path.join(home_dir,".cache/backgrounds/lockscreen"))

    subprocess.run(["chmod", "+x", os.path.join(home_dir, "scripts/gsettings.sh")])
    subprocess.run(["bash", os.path.join(home_dir, "scripts/gsettings.sh")])
    print("Set theme using gsettings")

    print("""\
####################
##### Bash Cat #####
####################\
""")

    # TODO download bash cat
    # shell command for reference
    '''
    echo "Installing bash cat"
    mkdir "$tempdir/bash-cat-with-cat"
    git clone https://github.com/RealStickman/bash-cat-with-cat.git "$tempdir/bash-cat-with-cat" &>/dev/null
    cp "$tempdir/bash-cat-with-cat/cat.sh" "$HOME/scripts/pieces/cat.sh"
    '''

    print("""\
########################################
############### Autostart ##############
########################################\
""")

    # create autostart directory
    os.makedirs(os.path.join(home_dir, ".config", "autostart"))

    # TODO check installed package with python
    # shell commands for reference
    '''
    # copy corectrl desktop file
    if [[ $(pacman -Q | grep corectrl) ]]; then
        cp /usr/share/applications/org.corectrl.corectrl.desktop ~/.config/autostart/org.corectrl.corectrl.desktop
    fi
    '''

    print("""\
########################################
############### Services ###############
########################################\
""")

    # reload systemd user scripts
    subprocess.run(["systemctl", "--user", "daemon-reload"])

    # enable ssh-agent
    subprocess.run(["systemctl", "--user", "enable" ,"--now" ,"ssh-agent"])

    print("""\
########################################
############# Misc Config  #############
########################################\
""")

    # make scripts executable
    subprocess.run(["chmod", "+x", "-R", os.path.join(home_dir, ".config/polybar")])
    subprocess.run(["chmod", "+x", "-R", os.path.join(home_dir, ".config/sway/scripts")])
    subprocess.run(["chmod", "+x", "-R", os.path.join(home_dir, "scripts")])
    subprocess.run(["chmod", "+x", "-R", os.path.join(home_dir, ".local/share/applications")])

    # remove downloaded folder
    shutil.rmtree(tempdir)

    print("""\
########################################
############## Reloading  ##############
########################################\
""")

    # TODO implement this stuff
    # bash for reference
    '''
    # reload applications
    update-desktop-database ~/.local/share/applications/

    # sync doom-emacs only if it is installed
    if [[ -f  ~/.config/emacs/bin/doom ]]; then
        ~/.config/emacs/bin/doom sync &
        pids="$pids $!"
    fi

    if [ $XDG_SESSION_DESKTOP == "sway" ]; then
        swaymsg reload
        echo "Reloaded sway"
    fi

    # wait for all background jobs to finish
    wait $pids && echo "Finished background jobs"
    '''

if __name__ == "__main__":
    ####################
    #### Arguments  ####
    ####################
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--theme", help="Select a different theme", action="store_true")
    parser.add_argument("-f", "--firefox", help="Update firefox config", action="store_true")

    # parse arguments
    args = parser.parse_args()

    select_theme = args.theme
    copy_firefox = args.firefox

    main()