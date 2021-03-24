#! /bin/bash

set -e

V_ANTD="1.0.6b"
V_LUA="0.5.2b"
V_WTERM="1.0.0b"
V_TUNNEL="0.1.0b"
V_CGI="1.0.0b"
V_PUBS="0.1.0a"
V_ANTOS=$(wget -qO- https://github.com/lxsang/antos/raw/master/release/latest)

mkdir -p /opt/www/htdocs

if [ "$1" = "full" ]; then
    # base server
    wget -O- https://get.iohub.dev/antd | bash -s "$V_ANTD"
    # base plugin
    wget -O- https://get.iohub.dev/antd_plugin | bash -s "lua-$V_LUA"
    wget -O- https://get.iohub.dev/antd_plugin | bash -s "wterm-$V_WTERM"
    wget -O- https://get.iohub.dev/antd_plugin | bash -s "tunnel-$V_TUNNEL"
    wget -O- https://get.iohub.dev/antd_plugin | bash -s "cgi-$V_CGI"
    # install antos

    [ -d /tmp/apub ] && rm -r /tmp/apub
    mkdir -p /tmp/apub
    cd /tmp/apub
    wget --no-check-certificate "https://github.com/lxsang/antd-tunnel-publishers/raw/master/dist/antd-publishers-$V_PUBS.tar.gz"
    tar xvzf antd-publishers-$V_PUBS.tar.gz
    cd antd-publishers-$V_PUBS
    ./configure --prefix=/opt/www && make && make install

    cd /opt/www

    # create the configuration file
    cat << EOF > config.ini
[SERVER]
plugins=/opt/www/lib/
plugins_ext=.so
database=/opt/www/database/
tmpdir=/opt/www/tmp/
statistic_fifo=/opt/www/tmp/antd_stat
maxcon=200
backlog=5000
workers = 4
max_upload_size = 10000000
ssl.cert=/opt/www/server.crt
ssl.key=/opt/www/server.key
ssl.cipher=ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256

gzip_enable = 1
gzip_types = text\/.*,.*\/css,.*\/json,.*\/javascript


[PORT:443]
htdocs=/opt/www/htdocs
ssl.enable=1
^\/os\/+(.*)$ = /os/router.lua?r=<1>&<query>

[AUTOSTART]
plugin = tunnel


[MIMES]
image/bmp=bmp
image/jpeg=jpg,jpeg
text/css=css
text/markdown=md
text/csv=csv
application/pdf=pdf
image/gif=gif
text/html=html,htm,chtml
application/json=json
application/javascript=js
image/png=png
image/x-portable-pixmap=ppm
application/x-rar-compressed=rar
image/tiff=tiff
application/x-tar=tar
text/plain=txt
application/x-font-ttf=ttf
application/xhtml+xml=xhtml
application/xml=xml
application/zip=zip
image/svg+xml=svg
application/vnd.ms-fontobject=eot
application/x-font-woff=woff,woff2
application/x-font-otf=otf
audio/mpeg=mp3,mpeg

[FILEHANDLER]
ls = lua
lua = lua
EOF
    # generate cert
    openssl  genrsa  -des3 -passout pass:1234 -out keypair.key 2048
    openssl rsa -passin pass:1234 -in keypair.key -out server.key
    openssl req -new -subj '/C=FR' -key server.key -out server.csr
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
fi

cd /opt/www/htdocs

wget --no-check-certificate "https://github.com/lxsang/antd-web-apps/raw/master/dist/antd_web_apps.tar.gz"
tar xvzf antd_web_apps.tar.gz
rm antd_web_apps.tar.gz
rm -r blog doc index.ls info talk get

cd /opt/www/htdocs/os
wget --no-check-certificate "https://github.com/lxsang/antos/raw/next-1.2.0/release/antos-$V_ANTOS.tar.gz"
tar xvzf antos-$V_ANTOS.tar.gz
rm antos-$V_ANTOS.tar.gz

echo "Install done..."
