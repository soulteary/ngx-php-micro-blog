# Nginx NGX-PHP Module Demo (MicroBlog)

[中文版本](./README.md)

Microlog example based on Nginx and Nginx module (NGX-PHP8), A high-performance implementation that does not use the combination of Nginx and PHP-FPM, which is safe and reliable.

![](./screenshots/docker.png)

Built on the official Nginx container, the base image is only 12MB.

## Screenshots

![](./screenshots/list.png)

## Usage

start docker container with compose:

```bash
docker-compose -f docker-compose.ngx-php.yml up
```

open browser：`http://localhost:8090`

![](./screenshots/post.png)
