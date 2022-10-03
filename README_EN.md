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

## Benchmark

Comparing `soulteary/ngx-php:8` and `php:8.1.10-apache-buster`。

### soulteary/ngx-php:8

```bash
wrk -t16 -c 100 -d 30s http://127.0.0.1:8090     
Running 30s test @ http://127.0.0.1:8090
  16 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    94.01ms   15.94ms 431.01ms   81.62%
    Req/Sec    64.02     11.33   148.00     74.26%
  30715 requests in 30.09s, 65.03MB read
Requests/sec:   1020.65
Transfer/sec:      2.16MB
```

### php:8.1.10-apache-buster (`opcache.enable=1`)

```bash
wrk -t16 -c 100 -d 30s http://127.0.0.1:8090     
Running 30s test @ http://127.0.0.1:8090
  16 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   132.92ms  158.49ms   1.98s    86.67%
    Req/Sec    54.38     56.83   670.00     94.88%
  22603 requests in 30.08s, 49.40MB read
  Socket errors: connect 0, read 0, write 0, timeout 112
Requests/sec:    751.53
Transfer/sec:      1.64MB
```