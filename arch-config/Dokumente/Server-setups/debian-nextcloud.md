# Nextcloud installation

*All commands assume being logged in as root user on the server unless noted otherwise.*  

Installing required packages  
```bash
apt install mlocate apache2 libapache2-mod-php mariadb-client mariadb-server wget unzip bzip2 curl php php-common php-curl php-gd php-mbstring php-mysql php-xml php-zip php-intl php-apcu php-redis php-http-request  
```

## Set up the database  
Just press enter when asked for a root password this time, as it has not yet been set.  
```bash
mysql -u root -p  
```

The command prompt should have changed to something similar to `MariaDB [(none)]>`  

```mysql
CREATE DATABASE nextcloud;  
```

```mysql
GRANT ALL ON nextcloud.* TO 'nextcloud'@'localhost' IDENTIFIED BY '<password>';  
```

```mysql
FLUSH PRIVILEGES;  
```

Exit the MariaDB prompt.  
```mysql
\q  
```

## Nextcloud installation

Change into the /var/www directory.  

Download the latest Nextcloud version (19.0.2 at the time of writing).  
```bash
wget https://download.nextcloud.com/server/releases/nextcloud-<version>.zip  
```

Unzip Nextcloud  
```bash
unzip nextcloud-<version>  
```

Change owner and group of the nextcloud directory.  
```bash
chown -Rfv www-data:www-data nextcloud  
```

Create the apache2 site configuration for Nextcloud.   
```bash
vi /etc/apache2/sites-available/nextcloud.conf  
```

Copy this configuration into the newly created file.  

```
<VirtualHost *:80>  
ServerAdmin webmaster@localhost  
DocumentRoot /var/www/nextcloud  
Alias /nextcloud "/var/www/nextcloud/"  
    
<Directory "/var/www/nextcloud/">  
Options +FollowSymlinks  
AllowOverride All  

<IfModule mod_dav.c>  
Dav off  
</IfModule>  

Require all granted  

SetEnv HOME /var/www/nextcloud  
SetEnv HTTP_HOME /var/www/nextcloud  
</Directory>  

ErrorLog ${APACHE_LOG_DIR}/nextcloud_error_log  
CustomLog ${APACHE_LOG_DIR}/nextcloud_access_log common  
</VirtualHost>  
```

Enable the nextcloud config and disable the default config.  
```bash
a2ensite nextcloud.conf && a2dissite 000-default.conf
```
```bash
systemctl restart apache2 && systemctl status apache2
```

Final configuration has to be done in the Nextcloud webinterface.  

## HTTPS setup





