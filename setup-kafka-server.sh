#!/usr/bin/env bash

IMPLY_PATH=/root/imply-$implyversion

# Setup kafka host name
if [[ -z "$KAFKA_HOST_NAME" ]]; then
        sed -i 's/'"kafka-zoo-svc"'/'"$KAFKA_HOST_NAME"'/g' ${IMPLY_PATH}/conf/tranquility/kafka.json
fi
