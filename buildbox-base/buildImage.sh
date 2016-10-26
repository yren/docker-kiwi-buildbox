#!/bin/bash
if [ -z "$1" ]
  then
    echo "No branch supplied, should perform like : $0 0.1"
    exit 1
fi
branch=$1
rm -rf target
mkdir -p target/data
tar -zxvf data/docker/docker-1.11.2.tgz -C target/data/