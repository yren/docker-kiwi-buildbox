#!/bin/bash

if [ "$USER" != "root" ]; then
    echo "run with sudo"
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "Usage: $0 workspace"
    exit 1
fi

WORKSPACE=$1

cd $(dirname $0)
mkdir -p /rt/toolkit
chmod -R 777 /rt/toolkit
rm /rt/toolkit/utils.sh
rm -rf /rt/build
ln -s $PWD/utils.sh /rt/toolkit/utils.sh
ln -s $WORKSPACE /rt/build
