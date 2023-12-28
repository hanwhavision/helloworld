FROM ubuntu:22.04

USER root

ARG user=jenkins
ARG pw=5dkdlxlT!
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000

ENV USER $user
ENV HOME /home/$USER
ENV JENKINS_WORK_TOP ${HOME}/Dev
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_JOBS /var/jenkins_home/jobs
ENV JENKINS_SHARE /usr/share/jenkins
ENV JENKINS_EXTEND_UTILS ${JENKINS_SHARE}/extend_utils
ENV JENKINS_REF ${JENKINS_SHARE}/ref
ENV JENKINS_OPT /opt
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}


#SSL certificate
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y wget
RUN wget http://55.101.212.22/CA/somansa.crt
RUN mkdir /usr/share/ca-certificates/extra/
RUN cp somansa.crt /usr/share/ca-certificates/extra/
RUN echo "extra/somansa.crt" | tee -a /etc/ca-certificates.conf
## at system
RUN update-ca-certificates
## at java
#ARG CACERTS=/opt/java/openjdk/lib/security/cacerts
#RUN keytool -importcert -file "/usr/share/ca-certificates/extra/somansa.crt" -alias "somansa" -keystore "${CACERTS}" -storepass "changeit" -noprompt

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common \
    python3-software-properties

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bash \
    bc \
    build-essential \
    openssl \
    sudo \
    tar \
    u-boot-tools \
    bison \
    curl \
    flex \
    git \
    git-core \
    gnupg \
    g++ \
    g++-multilib \
    libxml2-utils \
    nodejs \
    npm \
    openjdk-17-jdk \
    ssh \
    tree \
    unzip \
    vim \
    wget \
    zip

#Set bash
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

#locale
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y language-pack-en
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#clear apt cache
RUN rm -rf /var/lib/apt/lists/*

########################### Create account 'Jenkins' #####################################
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user} \
    && usermod -aG sudo ${user} \
    && echo "${user}:${pw}" | chpasswd \
    && echo -e "${user}\tALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}"

####################################### Config ###################################################################

# SET JENKINS_WORK_TOP into container
RUN mkdir -p ${JENKINS_WORK_TOP} \
  && chown -R ${user}:${group} ${HOME} \
  && chown -R ${user}:${group} ${JENKINS_WORK_TOP}

# Jenkins home dir
RUN mkdir -p ${JENKINS_HOME} \
  && chown -R ${user}:${group} ${JENKINS_HOME}

# Set Bashrc for convenience
COPY bash.bashrc /etc/bash.bashrc

# change time zone
RUN ln -nsf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# copy swarm-client.jar
ADD swarm-client.jar ${JENKINS_SHARE}/swarm-client.jar
RUN chmod 777 ${JENKINS_SHARE}/swarm-client.jar

# provisioning shell
COPY jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod 777 /usr/local/bin/jenkins.sh

################################ EntryPoint #####################################################################
USER jenkins
WORKDIR $JENKINS_WORK_TOP
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]