#vi mode for fish
#fish_vi_key_bindings
fish_default_key_bindings

#if status is-interactive
#and not set -q TMUX
#    exec tmux
#end

# change greeting
set fish_greeting "Good Morning! Nice day for fishing ain't it! Hu ha!"

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
set fish_color_cwd yellow
set fish_color_autosuggestion brwhite
set fish_color_user yellow
set fish_color_host brwhite
set fish_color_host_remote brwhite
set fish_color_cancel brred

# environment variables
set RANGER_LOAD_DEFAULT_RC FALSE
#set EDITOR "/usr/bin/emacs --no-window-system"
#set VISUAL "/usr/bin/emacs --no-window-system"
set EDITOR "/usr/bin/vim"
set VISUAL "/usr/bin/vim"

# add paths
set fish_user_paths "$HOME/.emacs.d/bin/" $fish_user_paths
set fish_user_paths "$HOME/scripts/in_path" $fish_user_paths
set fish_user_paths "$HOME/.local/bin" $fish_user_paths

# use sudo !! to run the last command as root
function sudo --description "Replacement for Bash 'sudo !!' command to run last command using sudo."
    if test "$argv" = !!
    eval command sudo $history[1]
else
    command sudo $argv
    end
end

# edit with emacs
alias emacs="/usr/bin/emacs --no-window-system"

# sudo alias
alias fucking=sudo

# alias cat
alias cat="$HOME/scripts/pieces/cat.sh"

#update config
alias upconf='~/scripts/arch-config.sh'

#download & execute setup
alias setup='git clone https://gitlab.com/RealStickman-arch/setup && cd setup && bash install.sh'

#notification
alias notify='notify-send "Terminal" "Your command finished!" --icon=dialog-information'

#list
alias ls='ls --color=auto'
#alias la='ls -a'
#alias ll='ls -la'
#alias l='ls'
#alias l.="ls -A | egrep '^\.'"

# fix obvious typo's
#alias cd..='cd ..'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# continue download
alias wget="wget -c"

# Aliases for software managment
alias pacman='pacman --color auto'
#alias update='yay -Syu --sudoloop'
alias update='paru -Syu --sudoloop --newsonupgrade --upgrademenu --combinedupgrade; notify'

#grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

#get fastest mirrors in your neighborhood
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
#alias mirror-delay="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
#alias mirror-score="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
#alias mirror-age="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

#mounting the folder Public for exchange between host and guest on virtualbox
#alias vbm="sudo mount -t vboxsf -o rw,uid=1000,gid=1000 Public /home/$USER/Public"

#youtube-dl
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "

alias ytv-best="youtube-dl -f bestvideo+bestaudio "

#Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Clean cached packages
alias cleancache='paru -Sc'

#get the error messages from journalctl
#alias jctl="journalctl -p 3 -xb"

#cpu-x as sudo
alias cpu-x="sudo cpu-x"

#wireguard
alias wgs="sudo wg show"
alias wgqu="sudo wg-quick up"
alias wgqd="sudo wg-quick down"

#execute stuff
neofetch
