FROM yren:kiwi-baselayout:0.1
MAINTAINER Yufei <renyufei@gmail.com>

ENV JAVA_VERSION=8u66 \
    JAVA_BUILD_VERSION=b17 \
    MAVEN_VERSION=3.3.3 \
    MAVEN_HOME=/usr/share/maven \
    JAVA_HOME=/usr/java/latest

COPY data/root/* /

RUN set -x; \
    yum -y groupinstall 'Development Tools' \
    && curl -fSLk --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$JAVA_BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -o /tmp/jdk.rpm \
    && yum -y install docker-engine \
    && yum -y install /tmp/jdk.rpm \
    && alternatives --install /usr/bin/java java /usr/java/latest/bin/java 200000 \
    && alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 200000 \
    && alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000 \
    && alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000 \
    && rm -f /tmp/jdk.rpm \
    && curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
    && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
    && yum -y install readline-devel \
    && yum -y clean all \
    && rm -rf /var/cache/yum/* \
    && echo "alias remake='remake -x'" >> /root/.bashrc \
    && curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && ./awscli-bundle/install -b ~/bin/aws \
    
ENV PATH=~/bin:$PATH