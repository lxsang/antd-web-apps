#! /bin/bash

set -e
# base server
wget -O- https://get.bitdojo.dev/antd | bash -s "1.0.6b"
# base plugin
wget -O- https://get.bitdojo.dev/antd_plugin | bash -s "lua-0.5.2b wterm-1.0.0b tunnel-0.1.0b"
# install antos

mkdir -p /opt/www/htdocs

cd /opt/www/htdocs

wget --no-check-certificate "https://github.com/lxsang/antos/raw/master/dist/antos-1.0.0.tar.gz"
tar xvzf antos-1.0.0.tar.gz

wget --no-check-certificate "https://github.com/lxsang/antd-web-apps/raw/master/dist/antd_web_apps.tar.gz"
tar xvzf antd_web_apps.tar.gz
