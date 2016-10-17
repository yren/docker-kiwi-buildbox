# Build image & Push to registry in auto shell
./MannualBuild.sh repo_ip parent_image git_remote image_tag opt1 opt2 .. optn
it will get parent_image from docker repo_ip
got to git_remote to check out code
execute ./build.sh under git_remote
tag image as image_tag
for opt1 opt2 .. optn is parameter will be used for build.sh(such as rcom-uk)
please define image name as echo output in last line of build.sh
it will generate a debug.log in run time
and read last line for this file for image name
after that it will pull docker image to repo_ip, with image name with image_tag

test:
 execute samples to make rcom-uk images
 docker pull 10.35.59.44:5000/rcom/rcom-uk:CKB-9894
 docker run --rm -p 8080:8080 -e environment=qa7 -it 10.35.59.44:5000/rcom/rcom-uk:CKB-9894
 

Samples:
./MannualBuild.sh rcom-uk CKB-9894 tomcat8-t1 10.35.59.44 rcom-all
./MannualBuild.sh tomcat8-t1 CKB-9894 tomcat:8 10.35.59.44 docker-tomcat8-t1

To be enhancement:
Business
1. Upgrade to support Httpd images
2. Upgrade to support win-us
3. Upgrade with auto build rcom-edtion after T1 image changed?
Features
1. Host file for remove repo_ip and parenet_image config
2. Remove sudo
3. Upgrade to docker images or other CI tools