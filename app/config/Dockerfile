FROM nginx:1.17-alpine

RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/nginx.conf

COPY api-server/nginx.conf /etc/nginx/nginx.conf
COPY api-server/fastcgi.conf /etc/nginx/fastcgi.conf
