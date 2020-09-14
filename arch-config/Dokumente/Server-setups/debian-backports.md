# Add buster backports  

*All commands assume being logged in as root user on the server unless noted otherwise.*  

Appends the appropriate line to the apt sources list.  
```bash
echo 'deb http://deb.debian.org/debian buster-backports main contrib non-free' >> /etc/apt/sources.list  
```
