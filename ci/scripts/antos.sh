#! /bin/bash
BRANCH="ci"
PRJ="antos"
DEST="/opt/www/htdocs/"
# /opt/www/htdocs
REPO="https://github.com/lxsang/$PRJ.git"

if [ ! -z $1 ]; then
    BRANCH="$1"
fi
{
    echo "Build date:  $(date)"
    echo "Building $PRJ using branch $BRANCH..."
    if [ -d "/tmp/ci/$PRJ" ]; then
        echo "Clean up /tmp/ci/$PRJ"
        rm -rf /tmp/ci/$PRJ
    else
        echo "Creating /tmp/ci/"
        mkdir -p "/tmp/ci"
    fi
    cd /tmp/ci || (echo "Unable to change directory to /tmp/ci" && exit 1)
    echo "Cloning $PRJ (branch $BRANCH) to /tmp/ci..."
    git clone -b "$BRANCH" --single-branch --depth=1 "$REPO"
    cd "$PRJ" || (echo "Unable to change directory to source code folder" && exit 1)
    npm i @types/jquery
    mkdir -p "$DEST/os"
    BUILDDIR="$DEST" make release
    mkdir -p "$DEST/grs"
    BUILDDIR="$DEST" make standalone_tags
    echo "Done!"
} 2>&1 | tee "/opt/www/htdocs/ci/log/${PRJ}_${BRANCH}.txt"
