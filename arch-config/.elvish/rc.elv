##############################
#####       prompt       #####
##############################
# "tilde-abbr" abbreviates home directory to a tilde.
# default prompt
#edit:prompt = { styled (whoami) bold red; styled ✸ bold yellow; styled (hostname) cyan; put ' '; tilde-abbr $pwd; put '❱ ' }
# custom prompt
edit:prompt = { styled (whoami) bold red; styled ✸ bold yellow; styled (hostname) cyan; put ' '; styled (tilde-abbr $pwd) yellow; put '> ' }

# "constantly" returns a function that always writes the same value(s) to
# output; "styled" writes styled output.
# default rightprompt
#edit:rprompt = (constantly (styled (whoami)✸(hostname) inverse))
# custom rightprompt
edit:rprompt = (constantly (put ''))

##############################
#####     completion     #####
##############################
# make completion case insensitive
edit:completion:matcher[''] = [seed]{ edit:match-prefix $seed &ignore-case=$true }

##############################
#####      aliases       #####
##############################
# ls colored output
fn ls [@a]{ e:ls --color $@a }

# emacs in terminal
fn emacs [@a]{ /usr/bin/emacs --no-window-system $@a }

# use neovim instead of vim
fn vim [@a]{ /usr/bin/nvim $@a }

# bash cat
fn cat [@a]{ $E:HOME/scripts/pieces/cat.sh $@a }

# update config
fn upconf [@a]{ $E:HOME/scripts/arch-config.sh $@a }

##############################
#####       other        #####
##############################
# execute stuff
neofetch
