#!/bin/bash

tmp_dir=$(mktemp -d)

docker run -d --name bind -v $PWD/named.conf:/etc/bind/named.conf:ro -v $PWD/example.com.zone:/etc/bind/example.com.zone:ro -p 5454:53/udp -p 5454:53 -it quay.io/geonet/geonet-dns

dig +noall +answer -p5454 @localhost dns1.example.com | tee -a ${tmp_dir}/output.log
dig +noall +answer +tcp -p5454 @localhost dns1.example.com | tee -a ${tmp_dir}/output.log
dig +noall +answer -p5454 @localhost www.example.com | sort | tee -a ${tmp_dir}/output.log
dig +noall +answer -p5454 @localhost example.com MX | sort | tee -a ${tmp_dir}/output.log

dig +noall +answer -p5454 @localhost fail.example.com | tee -a ${tmp_dir}/output.log

dig +noall +answer -p5454 @localhost google-public-dns-a.google.com | tee -a ${tmp_dir}/output.log

echo "Container says:"
docker logs bind
docker stop bind
docker rm bind

echo "Checking against expected output."

diff -u - ${tmp_dir}/output.log <<EOF
dns1.example.com.	86400	IN	A	10.0.1.1
dns1.example.com.	86400	IN	A	10.0.1.1
services.example.com.	86400	IN	A	10.0.1.10
services.example.com.	86400	IN	A	10.0.1.11
www.example.com.	86400	IN	CNAME	services.example.com.
example.com.		86400	IN	MX	10 mail.example.com.
example.com.		86400	IN	MX	20 mail2.example.com.
google-public-dns-a.google.com.	86400 IN A	8.8.8.8
EOF

ret=$?

rm -rf ${tmp_dir}

exit $ret
# vim: set ts=4 sw=4 tw=0 :
