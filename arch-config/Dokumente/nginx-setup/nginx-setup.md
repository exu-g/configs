# Nginx Setup  

[Original video this guide is based on.](https://youtu.be/OWAqilIVNgE)  

## Walkthrough  

Install programs  
```
apt install nginx certbot python-certbot-nginx
```

Available site configs can be found under /etc/nginx/sites-available/  

To activate a config symbolic link it to /etc/nginx/sites-enabled/  
```
ln -s /etc/nginx/sites-available/[config] /etc/nginx/sites-enabled/
```

Create directory in /var/www/[site] and create an index.html file for basic functionality.  

To set up https run  
```
certbot --nginx
```

Automatic cert renewal  
```
crontab -e
```

In crontab enter the following line  
```
1 1 1 * * certbot renew
```
