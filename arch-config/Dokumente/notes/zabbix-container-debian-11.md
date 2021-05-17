# Zabbix in Container on Debian 11

`# apt install podman`  

Create pod  
`# podman pod create --name zabbix -p 8808:8080 -p 10051:10051`  

`$ mkdir -p /home/debian/zabbix-mysql`  

Create database container  
```
# podman run --name zabbix-mysql -t \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix" \
      -e MYSQL_ROOT_PASSWORD="rootpass" \
      -v /home/debian/zabbix-mysql/:/var/lib/mysql/:Z \
      --restart=always \
      --pod=zabbix \
      -d docker://mysql:8.0 \
      --character-set-server=utf8 --collation-server=utf8_bin \
      --default-authentication-plugin=mysql_native_password
```

Create zabbix server  
```
# podman run --name zabbix-server -t \
                  -e DB_SERVER_HOST="127.0.0.1" \
                  -e MYSQL_DATABASE="zabbix" \
                  -e MYSQL_USER="zabbix" \
                  -e MYSQL_PASSWORD="zabbix" \
                  -e MYSQL_ROOT_PASSWORD="rootpass" \
                  --restart=always \
                  --pod=zabbix \
                  -d docker://zabbix/zabbix-server-mysql
```

Create web interface
```
# podman run --name zabbix-web -t \
                  -e ZBX_SERVER_HOST="127.0.0.1" \
                  -e DB_SERVER_HOST="127.0.0.1" \
                  -e MYSQL_DATABASE="zabbix" \
                  -e MYSQL_USER="zabbix" \
                  -e MYSQL_PASSWORD="zabbix" \
                  -e MYSQL_ROOT_PASSWORD="rootpass" \
                  --restart=always \
                  --pod=zabbix \
                  -d docker://zabbix/zabbix-web-nginx-mysql
```

`# apt install nginx`  

`# vim /etc/nginx/sites-available/zabbix.conf`  
```
server {
    server_name DOMAIN_NAME;

    # Security / XSS Mitigation Headers
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    location = / {
        return 302 https://$host/web/;
    }

    location / {
        # Proxy main traffic
        proxy_pass http://127.0.0.1:8808;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Protocol $scheme;
        proxy_set_header X-Forwarded-Host $http_host;
    }

    listen [IPV6]:443 ssl; #set ipv6 address
    ssl_certificate /etc/letsencrypt/live/DOMAIN_NAME/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/DOMAIN_NAME/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}

server {
    if ($host = DOMAIN_NAME) {
        return 301 https://$host$request_uri;
    }

    listen [IPV6]:80; #set ipv6 address
    server_name DOMAIN_NAME;
    return 404;
}
```

`# ln -s /etc/nginx/sites-available/zabbix.conf /etc/nginx/sites-enabled/`  

`# systemctl restart nginx`  
