#!/bin/sh
source /rt/toolkit/utils.sh

# $1: branch
# $2: build base flag
if [ -z "$1" ]
  then
    echo "No branch number supplied, should perform like : $0 0.1"
    exit 1
fi

if [ "$2" == "true" ]; then
    rm -rf buildbox-base/target
    mkdir -p buildbox-base/target/data
    tar -zxvf buildbox-base/data/docker/docker-1.11.2.tgz -C buildbox-base/target/data/
    imageName=kiwi-buildbox-base
    echo
    echo "**********************************************************************"
    echo "* docker build $dockerrepo/$imageName:$1 "
    echo "**********************************************************************"
    echo
    docker build -f docker-build-box-base/Dockerfile $dockerBuildArg --rm -t $dockerrepo/$imageName:$1 docker-build-box-base
    echo
    echo "**********************************************************************"
    echo "* docker push $dockerrepo/$imageName:$1 "
    echo "**********************************************************************"
    echo
    pushImageToDockerHub $imageName $1
fi

imageName=kiwi-buildbox
echo
echo "**********************************************************************"
echo "* docker build $dockerrepo/$imageName:$1 "
echo "**********************************************************************"
echo
docker build -f buildbox/Dockerfile $dockerBuildArg --rm -t $dockerrepo/$imageName:$1 buildbox
echo
echo "**********************************************************************"
echo "* docker push $dockerrepo/$imageName:$1 "
echo "**********************************************************************"
echo
pushImageToDockerHub $imageName $1
