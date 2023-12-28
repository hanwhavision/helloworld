#! /bin/bash -e

echo "Start jenkins.sh"
################## essential nwc jenkins swarm  #########################
echo "Set Volume auth to jenkins"
sudo chown 1000:1000 $JENKINS_HOME
sudo chown 1000:1000 $JENKINS_WORK_TOP

echo "Make symbolic link to $JENKINS_HOME"
sudo ln -nsf $JENKINS_HOME /var/lib/jenkins

################### SWARM ARGS Set #################################

echo "Set Jenkins swarm args"
SWARM_ARGS=""
if [ -n "${JENKINS_USER}" ]; then
    SWARM_ARGS="${SWARM_ARGS} -username ${JENKINS_USER}"
fi

if [ -n "${JENKINS_PASS}" ]; then
    SWARM_ARGS="${SWARM_ARGS} -password ${JENKINS_PASS}"
fi

if [ -n "${SWARM_EXECUTORS}" ]; then
    SWARM_ARGS="${SWARM_ARGS} -executors ${SWARM_EXECUTORS}"
fi

if [ -n "${SWARM_LABELS}" ]; then
    SWARM_ARGS="${SWARM_ARGS} -labels ${SWARM_LABELS}"
fi

if [ -n "${SWARM_MODE}" ]; then
    SWARM_ARGS="${SWARM_ARGS} -mode ${SWARM_MODE}"
fi

if [ -n "${SWARM_NAME}" ]; then
    SWARM_ARGS="${SWARM_ARGS} -name ${SWARM_NAME}"
fi

if [ -n "${SWARM_MASTER_URL}" ]; then
   SWARM_ARGS="${SWARM_ARGS} -master ${SWARM_MASTER_URL}"
else
   jenkins_master="http://localhost:${JENKINS_PORT:-8080}"
   SWARM_ARGS="${SWARM_ARGS} -master ${jenkins_master}"
fi

################### Run jenkins swarm client #######################
echo "Run java -jar ${JENKINS_SHARE}/swarm-client.jar"
if [ -z "$SWARM_ARGS" ]; then
   echo "no set swarm args";
   exec java -jar "${JENKINS_SHARE}/swarm-client.jar" -fsroot ${JENKINS_WORK_TOP} "$@"
else
   exec java -jar "${JENKINS_SHARE}/swarm-client.jar" -fsroot ${JENKINS_WORK_TOP} ${SWARM_ARGS}
fi
