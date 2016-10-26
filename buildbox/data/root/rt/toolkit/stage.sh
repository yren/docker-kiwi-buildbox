#!/bin/bash
source /rt/toolkit/utils.sh

#####################################################################################
#$1 git project
#$2 git branch, docker tag
#$3 if build dependence (true,false)
#####################################################################################
project=$1
tag=$2
buildDependence=$3

if [ $# -lt 3 ]; then
    echo "Usage: $0 project tag [true|false]"
    exit 1
fi

build $project $tag $buildDependence
buildImage $project $tag $buildDependence
