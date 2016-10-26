#!/bin/bash
set -x
dockerrepo="yren"
buildhome="/rt/build"
dockerBuildArg="--build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy"
gitAddr="https://github.com/yren"
#####################################################################################
#$1 git project
#$2 git branch, docker image tag
#$3 if build dependence (true,false)
#####################################################################################

build(){
  fromDir=$PWD
  echo "cd $buildhome"
  cd $buildhome
  projectName=$1
  branch=$2
  wget ${gitAddr}/${projectName}/archive/${branch}.zip -O ${projectName}.zip \
    && unzip -o ${projectName}.zip && rm -rf ${projectName}.zip
  cd $buildhome/$projectName-${branch}
  if [ -f "build.sh" ]; then
    shift # cut $1
    ./build.sh $@
  elif [ -f "pom.xml.m4" ]; then
    m4 -D__VERSION__=$branch pom.xml.m4 > pom.xml
    mvn clean deploy -Dmaven.test.skip=true -Dmaven.javadoc.skip=true
  else
    echo "No build.sh nor pom.xml.m4 found under $projectName, skip!"
  fi
  echo "cd $fromDir"
  cd $fromDir
}

buildImage(){
  fromDir=$PWD
  projectName=$1
  branch=$2
  echo "cd $buildhome/${projectName}-${branch}"
  cd $buildhome/${projectName}-${branch}
  if [ -f "buildImage.sh" ]; then
    shift # cut $1
    ./buildImage.sh $@
  elif [ -f "Dockerfile" ]; then
    echo
    echo "**********************************************************************"
    echo "* docker build $projectName:$branch "
    echo "**********************************************************************"
    echo
    docker build $dockerBuildArg --rm -t $dockerrepo/$projectName:$branch .
    echo
    echo "**********************************************************************"
    echo "* docker push  $projectName:$branch "
    echo "**********************************************************************"
    echo
    docker push $dockerrepo/$projectName:$branch
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
  docker pull $dockerrepo/$1:$2
}

pushImageToDockerHub() {
  docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
  docker pull $dockerrepo/$1:$2
}
