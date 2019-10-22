#!/bin/bash
HTTP_PROXY="http://proxy-chain.intel.com:911/"
HTTPS_PROXY="http://proxy-chain.intel.com:911/"
DOCKER_BUILD_OPTS="--build-arg http_proxy=$HTTP_PROXY --build-arg https_proxy=$HTTPS_PROXY"

HOST_PORT=9000
CONTAINER_PORT=9000

IMAGE_NAME="webapp"
CONTAINER_NAME="webapp-image"
DEMONIZE=$1

docker rmi $IMAGE_NAME --force
docker image prune --force
docker container prune --force
docker kill $CONTAINER_NAME
docker build $DOCKER_BUILD_OPTS -t $IMAGE_NAME . || exit

if [ $DEMONIZE ]; then
	docker run --name $CONTAINER_NAME -p $HOST_PORT:$CONTAINER_PORT -itd --env http_proxy=$HTTP_PROXY --env https_proxy=$HTTPS_PROXY $IMAGE_NAME || exit
else
	docker run --name $CONTAINER_NAME -p $HOST_PORT:$CONTAINER_PORT -it --env http_proxy=$HTTP_PROXY --env https_proxy=$HTTPS_PROXY $IMAGE_NAME || exit
fi

docker ps
