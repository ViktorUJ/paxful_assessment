FROM nginx:1.17-alpine

RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY fastcgi.conf /etc/nginx/fastcgi.conf
