# Git SSH keys

Create a new ssh key.  
```bash
ssh-keygen -t rsa -b 4096 -C "<name>"
```

Change into the BASH shell and enter the next two commands in there  
```bash
eval "$(ssh-agent -s)"
```

```bash
ssh-add <path to private key file>
```

Add the public key to the github/gitlab profile.  

Set the ssh keyfile in $HOME/.ssh/config. Make sure to edit with sudo privileges.  

For github:  
```
Host github.com
      IdentityFile <path to private key file>
```

For gitlab:  
```
Host gitlab.com
      IdentityFile <path to private key file>
```

Make sure to clone all projects through the ssh address instead of https.  
```bash
git clone <repository ssh address>
```


