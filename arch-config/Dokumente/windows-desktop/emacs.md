# Installing

## git

Go to the [git homepage](https://git-scm.com/) and install it.  

## emacs

Go to the [emacs homepage](https://www.gnu.org/software/emacs/) and install it.  
Add the `<location>\emacs\x86_84\bin` directory to your PATH in the environment variables.  

### Shortcut

Create a shortcut to `<location>\emacs\x86_64\bin\runemacs.exe`  
Edit the shortcut to execute in your home directory `C:\Users\<user>`  

## HOME

Add the path to your home to the environment variables.  

New variable -> HOME -> `C:\Users\<user>`  

## doom-emacs

Open git bash  
```bash
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
```
```bash
~/.emacs.d/bin/doom install
```

Add `C:\Users\<user>\.emacs.d\bin` to your PATH.  

*Currently doesn't show emotes*  
*Missing ripgrep and fd*  
