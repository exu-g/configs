fish_default_key_bindings

# change greeting
set fish_greeting "Morning! Nice day for fishing ain't it! Hu ha!"

# Info:
# https://fishshell.com/docs/current/index.html#variables-for-changing-highlighting-colors
set fish_color_normal blue
set fish_color_command blue
set fish_color_quote bryellow
set fish_color_redirection
set fish_color_end brred
set fish_color_error red
set fish_color_param brblue
set fish_color_comment white
set fish_color_selection brcyan
set fish_color_search_match magenta
set fish_color_operator blue
set fish_color_escape green
set fish_color_autosuggestion brwhite
set fish_color_host_remote brwhite
set fish_color_cancel brred

# used in prompt
set fish_color_user --bold red
set fish_color_separator --bold yellow
set fish_color_host cyan
set fish_color_cwd yellow

# environment variables
# SSH Agent
set SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
#set SSH_AUTH_SOCK /run/user/1000/ssh-agent.socket
export SSH_AUTH_SOCK

# Defined in /home/marc/.config/fish/functions/fish_prompt.fish @ line 2
# slightly modified from defaults
function fish_prompt
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l normal (set_color normal)

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix '>'
    #if functions -q fish_is_root_user; and fish_is_root_user
    #    if set -q fish_color_cwd_root
    #        set color_cwd $fish_color_cwd_root
    #    end
    #    set suffix '#'
    #end

    # If we're running via SSH, change the host color.
    set -l color_host $fish_color_host
    #if set -q SSH_TTY
    #    set color_host $fish_color_host_remote
    #end

    # Write pipestatus
    # If the status was carried over (e.g. after `set`), don't bold it.
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" (set_color $fish_color_status) (set_color $bold_flag $fish_color_status) $last_pipestatus)

    echo -n -s (set_color $fish_color_user) "$USER" $normal (set_color $fish_color_separator) @ $normal (set_color $color_host) (prompt_hostname) $normal ' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status $suffix " "
    #echo -n -s (set_color --bold red) "$USER" $normal (set_color --bold yellow) @ $normal (set_color cyan) (prompt_hostname) $normal ' ' (set_color yellow) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status $suffix " "
end

# text editor
#set EDITOR "/usr/bin/emacs --no-window-system"
#set VISUAL "/usr/bin/emacs --no-window-system"
set EDITOR /usr/bin/vim
set VISUAL /usr/bin/vim

# add paths
set fish_user_paths /usr/bin/vendor_perl/ $fish_user_paths # global perl tools
set fish_user_paths "$HOME/.config/emacs/bin/" $fish_user_paths # new path
set fish_user_paths "$HOME/scripts/in_path" $fish_user_paths
set fish_user_paths "$HOME/.local/bin" $fish_user_paths
set fish_user_paths "$HOME/node_modules/.bin/" $fish_user_paths

# edit with emacs
alias emacs="/usr/bin/emacs --no-window-system"

# alias cat
alias cat="$HOME/scripts/pieces/cat.sh"

#notification
alias notify='notify-send "Terminal" "Your command finished!" --icon=dialog-information'

# ssh aliases to never bother with terminfo again
# needs python on the server
alias sshkp='kitty +kitten ssh use-python'
alias sshk='kitty +kitten ssh'

# alias for powershell
alias powershell='pwsh'

#list
alias ls='ls --color=auto'

# kill all wine and proton processes
alias killwine='ls -l /proc/*/exe 2>/dev/null | grep -P \'wine(64)?-preloader|wineserver|proton[^mail|\-bridge]\' | perl -pe \'s;^.*/proc/(\d+)/exe.*$;$1;g;\' | xargs -n 1 kill'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# continue download
alias wget="wget -c"

# Aliases for software managment
alias pacman='pacman --color auto'

# Update pip packages
alias pip-update="$HOME/scripts/pieces/pip-update.py"

#grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

#get fastest mirrors in your neighborhood
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"

# yt-dlp
alias yta-best="yt-dlp -f bestaudio --extract-audio "
alias ytv-best="yt-dlp -f bestvideo+bestaudio "
alias ytv-metadata="yt-dlp -f bestvideo+bestaudio --add-metadata --parse-metadata \"%(title)s:%(meta_title)s\" --parse-metadata \"%(uploader)s:%(meta_artist)s\" --write-info-json --write-thumbnail --embed-thumbnail --embed-subs --sub-langs \"en.*\" --merge-output-format mkv "

#Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Clean cached packages
alias cleancache='paru -Sc'

# lsblk to list more info
alias lsblkf="lsblk -o NAME,LABEL,RM,SIZE,RO,TYPE,FSTYPE,MOUNTPOINTS,MODEL,UUID"

# use color for ip command
alias ip="ip -c"

# rebuild broken packages
alias rebuild='paru -S --rebuild=yes (checkrebuild | awk \'{print $2}\')'

# process cpu usage per core instead of overall
alias btm="btm -n"
