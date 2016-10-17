#####################################################################################
#$1 rcom-betaus tomcat8-t1
#$2 CKB-9894
#####################################################################################
#$3 tomcat8-t1 tomcat:8
#$4 10.35.59.44
#$5 rcom-all docker-tomcat8-t1
#####################################################################################
tag=$4
parentimage=$2
dockerrepo=$1
gitrepo=$3
#####################################################################################
## move to dokcer? in the future
#echo "Env setting up"
#export JAVA_HOME=/usr/java/jdk
#####################################################################################
## basic information for parpare
echo "Get parent images " $parentimage " from docker repo " $dockerrepo
docker pull $dockerrepo:5000/rcom/$parentimage
cd ~/workspace
if [ -d "$gitrepo" ]; then
	echo "remove preivous code at " $gitrepo
	rm -rf $gitrepo
fi
echo "Change to code DIR"
git clone git@git.sami.int.thomsonreuters.com:rcom/$gitrepo.git --single-branch
cd ~/workspace/$gitrepo
shift 3
echo $@
echo ~/workspace/$gitrepo/build.sh $@
~/workspace/$gitrepo/build.sh $@ > debug.log
target=$(tail -1 debug.log)
echo $target
#####################################################################################
## upload
echo "tag and pull to docker repo"
docker tag rcom/$target:$tag $dockerrepo:5000/rcom/$target:$tag
docker push $dockerrepo:5000/rcom/$target:$tag
