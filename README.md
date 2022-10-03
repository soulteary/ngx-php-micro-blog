# Nginx NGX-PHP Module Demo (MicroBlog)

[English Ver](./README_EN.md)

使用 Nginx 模块 NGX-PHP 实现的一个简单的微博应用 Demo，不依赖 PHP-FPM 等技术栈，高效、安全、可靠。

![](./screenshots/docker.png)

基于 Nginx 官方容器构建，基础镜像仅 12MB。

## 界面预览

![](./screenshots/list.png)

## 使用方法

启动容器：

```bash
docker-compose -f docker-compose.ngx-php.yml up
```

打开浏览器：`http://localhost:8090`

![](./screenshots/post.png)
