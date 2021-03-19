FROM nginx:alpine
RUN apk add nginx-mod-http-lua && rm -rf /var/cache/apk/*
