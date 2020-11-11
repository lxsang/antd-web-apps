#! /bin/bash

# exit on error
set -e

if [ -z "$1" ]; then
    echo "Please specify the plugin in format name-xxx where [name] is the plugin name [xxx] is the plugin version number"
    exit 1
else
    name=$(echo ${1%-*})
    mkdir -p /tmp/antd
    rm -rf /tmp/antd/*
    echo "Downloading plugin $1"
    cd /tmp/antd
    wget --no-check-certificate "https://github.com/lxsang/antd-$name-plugin/raw/master/dist/$1.tar.gz"
    [[ -f "$1.tar.gz" ]] || {
        echo "Fail to download the source tarball"
        exit 1
    }
    echo "extracting source..."
    tar xzf "$1.tar.gz"
    [[ -d "$1" ]] || {
        echo "Cannot extract the tarball"
        exit 1
    }
    cd "$1"
    CPPFLAGS='-I/usr/local/ssl/include/' LDFLAGS='-L/usr/local/ssl/lib' ./configure --prefix=/opt/www --enable-debug=yes
    CPPFLAGS='-I/usr/local/ssl/include/' LDFLAGS='-L/usr/local/ssl/lib' make
    sudo make install
    echo "plugin installed"
fi
