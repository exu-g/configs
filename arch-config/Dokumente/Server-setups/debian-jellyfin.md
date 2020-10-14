# Jellyfin

*All commands assume being logged in as root user on the server unless noted otherwise.*  

```bash
apt install apt-transport-https lsb-release
```

```bash
wget -O key https://repo.jellyfin.org/debian/jellyfin_team.gpg.key
```

```bash
apt-key add key
```

```bash
echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/debian $( lsb_release -c -s ) main" | tee /etc/apt/sources.list.d/jellyfin.list
```

```bash
apt update
```

```bash
apt install jellyfin
```

Depending on the init system, different commands have to be used.  
```bash
service jellyfin status
```
```bash
systemctl status jellyfin
```
