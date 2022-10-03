# https://github.com/nginx-with-docker/nginx-docker-playground
FROM soulteary/prebuilt-nginx-modules:base-1.23.1-alpine AS Builder
RUN sed -i -E "s/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apk/repositories
RUN apk update && apk --no-cache add curl gcc g++ make musl-dev linux-headers gd-dev geoip-dev libxml2-dev libxslt-dev openssl-dev  pcre-dev perl-dev pkgconf zlib-dev libedit-dev ncurses-dev php8-dev php8-embed git unzip argon2-dev
ENV PHP_LIB=/usr/lib
WORKDIR /usr/src

ARG DEVEL_KIT_MODULE_CHECKSUM=e15316e13a7b19a3d2502becbb26043a464a135a
ARG DEVEL_KIT_VERSION=0.3.1
ARG DEVEL_KIT_NAME=ngx_devel_kit
RUN curl -L "https://github.com/vision5/ngx_devel_kit/archive/v${DEVEL_KIT_VERSION}.tar.gz" -o "v${DEVEL_KIT_VERSION}.tar.gz" && \
    echo "${DEVEL_KIT_MODULE_CHECKSUM}  v${DEVEL_KIT_VERSION}.tar.gz" | shasum -c && \
    tar -zxC /usr/src -f v${DEVEL_KIT_VERSION}.tar.gz && \
    mv ${DEVEL_KIT_NAME}-${DEVEL_KIT_VERSION}/ ${DEVEL_KIT_NAME}

# https://github.com/nginx-with-docker/ngx_http_php_module/blob/main/docker/master/Dockerfile.alpine
# https://github.com/nginx-with-docker/ngx_http_php_module-src/tree/master
ARG MODULE_CHECKSUM=aeef775b2beb8378cb295a4da29b80d98274e1fa
ARG MODULE_VERSION=master
ARG MODULE_NAME=ngx_http_php_module-src
ARG MODULE_SOURCE=https://github.com/nginx-with-docker/ngx_http_php_module-src
RUN curl -L "${MODULE_SOURCE}/archive/refs/heads/${MODULE_VERSION}.zip" -o "v${MODULE_VERSION}.zip" && \
    echo "${MODULE_CHECKSUM}  v${MODULE_VERSION}.zip" | shasum -c && \
    unzip "v${MODULE_VERSION}.zip" && \
    mv "$MODULE_NAME-$MODULE_VERSION" "$MODULE_NAME"

RUN cd /usr/src/nginx && \
    CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
    CONFARGS=${CONFARGS/-Os -fomit-frame-pointer -g/-Os} && \
    echo $CONFARGS && \
    ./configure --with-compat $CONFARGS --with-ld-opt="-Wl,-rpath,${PHP_LIB}" --add-dynamic-module=../${DEVEL_KIT_NAME} --add-dynamic-module=../${MODULE_NAME} && \
    make modules


FROM nginx:1.23.1-alpine

COPY --from=Builder /usr/lib/libphp.so          /usr/lib/
COPY --from=Builder /usr/lib/libargon2.so.1     /usr/lib/
COPY --from=Builder /lib/libz.so.1              /lib/
COPY --from=Builder /etc/php8/php.ini           /etc/php8/
COPY --from=Builder /usr/src/nginx/objs/ndk_http_module.so      /etc/nginx/modules/
COPY --from=Builder /usr/src/nginx/objs/ngx_http_php_module.so  /etc/nginx/modules/
ENV PHP_LIB=/usr/lib
COPY conf/nginx.conf /etc/nginx/
RUN mkdir -p /usr/share/nginx/html/data && \
    chown nginx:nginx /usr/share/nginx/html/data && \
    chmod 777 /usr/share/nginx/html/data