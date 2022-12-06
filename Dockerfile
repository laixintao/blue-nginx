From ubuntu:20.04

ARG nginx_version=1.23.2
ARG vts_version=0.2.1

ENV DEBIAN_FRONTEND=noninteractive

RUN true && \
    apt update && \
    apt install -y \
        build-essential \
        libpcre3-dev \
        libssl-dev \
        zlib1g-dev \
        libxslt-dev \
        libgeoip-dev \
        libgd-dev \
        git \
        curl

RUN true && \
    curl -sSL https://nginx.org/download/nginx-${nginx_version}.tar.gz -o nginx-source.tar.gz && \
    tar xvf nginx-source.tar.gz

RUN true && \
    curl -sS -L https://github.com/vozlt/nginx-module-vts/archive/refs/tags/v${vts_version}.tar.gz -o nginx-module-vts.tar.gz && \
    tar xvf nginx-module-vts.tar.gz && \
    mv /nginx-module-vts-${vts_version} /nginx-module-vts


RUN mv -v /nginx-${nginx_version} /nginx-build

WORKDIR nginx-build

RUN true && \
    ./configure \
        --sbin-path=/nginx-build/bin \
        --prefix=/usr/share/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --lock-path=/var/lock/nginx.lock \
        --pid-path=/run/nginx.pid \
        --modules-path=/usr/lib/nginx/modules \
        --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
        --http-proxy-temp-path=/var/lib/nginx/proxy \
        --http-scgi-temp-path=/var/lib/nginx/scgi \
        --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
        --add-module=/nginx-module-vts \
        --with-debug \
        --with-compat \
        --with-pcre-jit \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_realip_module \
        --with-http_auth_request_module \
        --with-http_v2_module \
        --with-http_dav_module \
        --with-http_slice_module \
        --with-threads \
        --with-http_addition_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_image_filter_module=dynamic \
        --with-http_sub_module \
        --with-http_xslt_module=dynamic \
        --with-stream=dynamic \
        --with-stream_ssl_module \
        --with-mail=dynamic \
        --with-mail_ssl_module

CMD ["bash", "-c", "make -j 8 && make install"]
