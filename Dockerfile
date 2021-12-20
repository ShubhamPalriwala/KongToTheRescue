FROM kong:2.2-alpine

COPY kong.conf /etc/kong/

USER root

COPY ./kong/plugins/kongtotherescue /custom-plugins/kongtotherescue

WORKDIR /custom-plugins/kongtotherescue

RUN luarocks make 

USER kong
