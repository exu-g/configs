#update config
alias upconf='~/scripts/arcolinux-config.sh'

#download & execute setup
alias setup='git clone https://gitlab.com/RealStickman-arcolinux/setup && cd setup && bash install.sh'

#doom
alias dooma='$HOME/.emacs.d/bin/doom'

#list
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -la'
alias l='ls'
alias l.="ls -A | egrep '^\.'"

# fix obvious typo's
alias cd..='cd ..'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# continue download
alias wget="wget -c"

# Aliases for software managment
alias pacman='sudo pacman --color auto'
alias update='yay -Syu'

#trizen updates everything
alias upall="yay -Syu --noconfirm && bash $HOME/scripts/arcolinux-config.sh"

#grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

#get fastest mirrors in your neighborhood
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

#mounting the folder Public for exchange between host and guest on virtualbox
alias vbm="sudo mount -t vboxsf -o rw,uid=1000,gid=1000 Public /home/$USER/Public"

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

#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#cpu-x as sudo
alias cpu-x="sudo cpu-x"

#wireguard
alias wgs="sudo wg show"
alias wgqu="sudo wg-quick up"
alias wgqd="sudo wg-quick down"

#execute stuff
neofetch
