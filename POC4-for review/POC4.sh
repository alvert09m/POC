#!/bin/bash
apt-get update
apt-get install awscli -y
apt-get install docker.io -y
CONTAINER='jlazarte2/test1'
CNT=$(docker ps -a | grep "$CONTAINER" | wc -l)
if (($CNT > 0)); then
    docker restart $CONTAINER
else
    docker run -d -p 80:80 --name justin jlazarte2/test1
fi
