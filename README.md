# Docker Nginx Proxy

A reverse proxy based on Nginx and LetsEncrypt using Docker.

## Setup
    
Copy `.env.example` to `.env` (and set the environment variables, if needed).

In your development environment, add host in `/etc/hosts` file:

```
127.0.0.1   your-domain.test
``` 
    
## Usage

To start the server without LetsEncrypt SSL (during development):

```
$ make up
```

To start the server with SSL in Swarm mode for production:

```
$ make deploy-ssl
```

Look inside the `Makefile` for more convenient commands.

## Basic auth

Create a `htpasswd` directory and generate username/password with the `htpasswd` utility:

```
$ mkdir htpasswd
$ htpasswd -Bc htpasswd/your-domain your-username
```

## SSL during development

Create self-signed SSL certificates for development:

```
$ openssl req -newkey rsa:2048 -nodes -keyout certs/your-domain.key -x509 -days 3650 -out certs/your-domain.crt
```

## conf.d example

An nginx config file for your domain can be placed inside the `conf.d` directory, with `your-domain.com.conf` as the filename:

```
# Redirect insecure www traffic to non-www SSL domain
server {
  listen 80;
  server_name www.your-domain.com;
  return 301 https://your-domain.com$request_uri;
}

# Redirect secure www traffic to non-www
server {
  listen 443 ssl;
  server_name www.your-domain.com;
  ssl_certificate /etc/nginx/certs/your-domain.com.crt;
  ssl_certificate_key /etc/nginx/certs/your-domain.com.key;
  # Uncomment the following in production
  # ssl_dhparam /etc/nginx/certs/your-domain.com.dhparam.pem;
  return 301 https://your-domain.com$request_uri;
}
```

## vhost.d example

Virtual host config can be placed inside the `vhost.d` directory, with `your-domain.com` as the filename:

```
server_tokens off;
client_max_body_size 10m;
```

## More info

See [nginx-proxy](https://github/nginx-proxy/nginx-proxy) and [docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) for more info.
