FROM nginx:alpine

ENV LUA_MODULE_VERSION	0.10.13
ENV DEVEL_KIT_VERSION	0.3.1

RUN cd /tmp && \
	apk add lua-resty-core && \ 
	apk add --virtual build-dependencies build-base luajit-dev zlib-dev pcre-dev && \
	wget -q https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
	wget -q https://github.com/openresty/lua-nginx-module/archive/v${LUA_MODULE_VERSION}.tar.gz -O lua-nginx-module-${LUA_MODULE_VERSION}.tar.gz && \
	wget -q https://github.com/vision5/ngx_devel_kit/archive/v${DEVEL_KIT_VERSION}.tar.gz -O ngx_devel_kit-${DEVEL_KIT_VERSION}.tar.gz && \
	tar -zxf nginx-${NGINX_VERSION}.tar.gz && \
	tar -zxf ngx_devel_kit-${DEVEL_KIT_VERSION}.tar.gz && \
	tar -zxf lua-nginx-module-${LUA_MODULE_VERSION}.tar.gz && \
	cd nginx-${NGINX_VERSION} && \
	export LUAJIT_LIB=/usr/lib && \
	export LUAJIT_INC=/usr/include/luajit && \
	./configure --with-compat --add-dynamic-module=../ngx_devel_kit-${DEVEL_KIT_VERSION} --add-dynamic-module=../lua-nginx-module-${LUA_MODULE_VERSION} && \
	make modules -j && \
	cp objs/ndk_http_module.so /usr/lib/nginx/modules/ && \
	cp objs/ngx_http_lua_module.so /usr/lib/nginx/modules/ && \
	echo 'load_module "modules/ndk_http_module.so";' > /etc/nginx/modules/10_devel_kit.conf && \
	echo 'load_module "modules/ngx_http_lua_module.so";' > /etc/nginx/modules/30_http_lua.conf && \
	cd - && \
	rm -rf nginx-* ngx_devel_kit-* lua-nginx-module-* && \
	apk del --purge build-dependencies && \
	rm -rf /var/cache/apk/*
