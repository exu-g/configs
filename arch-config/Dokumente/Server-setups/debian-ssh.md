# ssh

*All commands assume being logged in as root user on the server unless noted otherwise.*  

```bash
apt install openssh-server
```

```bash
systemctl enable ssh
```

Permit root login (will be restricted again later).
```bash
vi /etc/ssh/sshd_config
```
Find `PermitRootLogin without-password` and change it to `PermitRootLogin yes`. Remove the `#` in front of it if there is one.  
```bash
systemctl restart ssh
```

## Add ssh-keys  

*This command has to be run from the computer you want to have ssh access through keys later.*  
```bash
ssh-copy-id -i <file location> <user>@<ip/domain>
```
In <file location> the location of the ssh public keys has to be inserted. The default is ~/.ssh/id_rsa.pub.  
In case you have not yet created an ssh-key, run the following command.  
```bash
ssh-keygen
```

## Disable password access  

```bash
vi /etc/ssh/sshd_config
```
Find `PasswordAuthentication yes` and change it to `PasswordAuthentication no`. Remove the `#` in front of it if there is one.  
```bash
systemctl restart ssh
```



