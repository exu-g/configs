# Openproject

Creating folders for data  
`# mkdir -p /var/www/openproject/{pgdata,assets}`  

Create container  
```
# podman run -d -p 8423:80 --name openproject -e SECRET_KEY_BASE="$(head /dev/random | tr -dc A-Za-z0-9 | head -c 32 ; echo '')" \
    -v /var/www/openproject/pgdata:/var/openproject/pgdata \
    -v /var/www/openproject/assets:/var/openproject/assets \
    docker://openproject/community:11
```

Default user is `admin` with password `admin`  

`# vim /etc/nginx/sites-available/openproject`  
```
server {
    server_name DOMAIN_NAME;

    # Security / XSS Mitigation Headers
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    #location = / {
    #    return 302 https://$host/;
    #}

    location / {
        # Proxy main traffic
        proxy_pass http://127.0.0.1:8423/;
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

Enable config  
`# ln -s /etc/nginx/sites-available/(config) /etc/nginx/sites-enabled`  

Restart nginx  
`# systemctl restart nginx`  
