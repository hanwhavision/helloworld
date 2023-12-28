# Jenkins 2.361.2 (2022-10-05)
FROM jenkins/jenkins:2.426.2-lts
ENV JENKINS_REF /usr/share/jenkins/ref
ENV JENKINS_SHARE /usr/share/jenkins

USER root

ARG INPUT_UID=119
ARG INPUT_GID=119

#Change UID/GID for jenkins
RUN usermod -u ${INPUT_UID} jenkins
RUN usermod -g ${INPUT_GID} jenkins

#SSL certificate
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y wget
RUN wget http://55.101.212.22/CA/somansa.crt
RUN mkdir /usr/share/ca-certificates/extra/
RUN cp somansa.crt /usr/share/ca-certificates/extra/
RUN echo "extra/somansa.crt" | tee -a /etc/ca-certificates.conf
## at system
RUN update-ca-certificates
## at java
ARG CACERTS=/opt/java/openjdk/lib/security/cacerts
RUN keytool -importcert -file "/usr/share/ca-certificates/extra/somansa.crt" -alias "somansa" -keystore "${CACERTS}" -storepass "changeit" -noprompt

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    vim \
    tree \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN chown jenkins:jenkins -R ${HOME}
RUN chown jenkins:jenkins -R ${JENKINS_SHARE}
# COPY jenkins.sh /usr/local/bin/jenkins.sh

# Install plugin
COPY plugins.txt /home/jenkins/plugins.txt
RUN jenkins-plugin-cli -f /home/jenkins/plugins.txt

# User jenkins
USER jenkins