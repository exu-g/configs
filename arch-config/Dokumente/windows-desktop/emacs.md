# Installing

## git

Go to the [git homepage](https://git-scm.com/) and install it.  

## emacs

Go to the [emacs homepage](https://www.gnu.org/software/emacs/) and install it.  
Add the `<location>\emacs\bin` directory to your PATH in the environment variables.  

## doom-emacs

Open git bash  
```bash
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
```
```bash
~/.emacs.d/bin/doom install
```

Doom emacs can now be called from git cmd and git bash.  
To create a shortcut enter the following in target:  
```
<path to git-bash.exe> --cd-to-home -- start emacs
```
The icon can optionally be changed to the emacs logo by selecting a different symbol and navigating to the emacs.exe  

*Currently doesn't show emotes*  
