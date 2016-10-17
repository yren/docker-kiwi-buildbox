#!/bin/bash
set -x
dockerrepo="yren"
buildhome="/rt/build"
dockerBuildArg="--build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy"
gitAddr="https://github.com/yren/"
#####################################################################################
#$1 git project
#$2 git branch, docker image tag
#$3 if build dependence (true,false)
#####################################################################################

build(){
  fromDir=$PWD
  echo "cd $buildhome"
  cd $buildhome
  projectName=$(completePIName $1)
  git archive -v --format=tar --prefix=$projectName/ --remote=$gitAddr:$projectName.git $2  | tar x
  cd $buildhome/$projectName
  if [ -f "build.sh" ]; then
    shift # cut $1
    ./build.sh $@
  elif [ -f "pom.xml.m4" ]; then
    m4 -D__VERSION__=$2 pom.xml.m4 > pom.xml
    mvn clean deploy -Dmaven.test.skip=true -Dmaven.javadoc.skip=true
  else
    echo "No build.sh nor pom.xml.m4 found under $projectName, skip!"
  fi
  echo "cd $fromDir"
  cd $fromDir
}

buildImage(){
  fromDir=$PWD
  projectName=$(completePIName $1)
  echo "cd $buildhome/$projectName"
  cd $buildhome/$projectName
  if [ -f "buildImage.sh" ]; then
    shift # cut $1
    ./buildImage.sh $@
  elif [ -f "Dockerfile" ]; then
    echo
    echo "**********************************************************************"
    echo "* docker build $projectName:$2 "
    echo "**********************************************************************"
    echo
    docker build $dockerBuildArg --rm -t $dockerrepo/$projectName:$2 .
    echo
    echo "**********************************************************************"
    echo "* docker push  $projectName:$2 "
    echo "**********************************************************************"
    echo
    docker push $dockerrepo/$projectName:$2
  else
    echo "Error: No buildImage.sh nor Dockerfile found under $projectName, please check!"
    exit 1
  fi
  echo "cd $fromDir"
  cd $fromDir
}

#####################################################################################
#$1 docker image name
#$2 docker image tag
#####################################################################################

pullImageFromDockerHub(){
  docker pull $dockerrepo/$(completePIName $1):$2
}

#####################################################################################
#$1 git project / docker image name
#####################################################################################
completePIName(){
  PIName=$1
  if ! [[ $1 == *"/"* ]]; then
    PIName=yren/$1
  fi
  echo $PIName
}