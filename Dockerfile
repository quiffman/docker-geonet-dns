FROM alpine:3.3
MAINTAINER Richard Guest <r.guest@gns.cri.nz>

RUN apk add --update bind && rm -rf /var/cache/apk/*

EXPOSE 53/udp 53/tcp

CMD ["named", "-c", "/etc/bind/named.conf", "-g", "-u", "named"]

