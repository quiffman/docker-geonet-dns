Example
=======

```
docker build -t quay.io/geonet/geonet-dns .
docker run --rm --name bind -v $PWD/named.conf:/etc/bind/named.conf:ro -v $PWD/example.com.zone:/etc/bind/example.com.zone:ro -p 5454:53/udp -p 5454:53 -it quay.io/geonet/geonet-dns
```
