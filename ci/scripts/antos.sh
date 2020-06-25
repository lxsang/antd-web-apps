#! /bin/bash
BRANCH="ci"
REPO="https://github.com/lxsang/antos.git"
DEST="/opt/www/htdocs/os"

if [ ! -z $1 ]; then
    BRANCH="$1"
fi
{
    echo "Build date:  $(date)"
    echo "Building AntOS using branch $BRANCH..."
    if [ -d "/tmp/ci" ]; then
        echo "Clean up /tmp/ci"
        rm  -rf /tmp/ci/*
    else
        echo "Creating /tmp/ci"
        mkdir -p "/tmp/ci"
    fi
    cd /tmp/ci || (echo "Unable to change directory to /tmp/ci" && exit 1)
    echo "Cloning Antos (branch $BRANCH) to /tmp/ci..."
    git clone -b "$BRANCH" --single-branch --depth=1 "$REPO"
    npm i @types/jquery
    cd antos || (echo "Unable to change directory to source code folder" && exit 1)
    BUILDDIR="$DEST" make release
    echo "Done!"
} > "/opt/www/htdocs/ci/log/antos_$BRANCH.txt"


