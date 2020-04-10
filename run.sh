#!/bin/bash
HTTP_PROXY="http://localproxy:12000/"
HTTPS_PROXY="http://localproxy:12000/"
#DOCKER_BUILD_OPTS="--build-arg http_proxy=$HTTP_PROXY --build-arg https_proxy=$HTTPS_PROXY"

HOST_PORT=9000
CONTAINER_PORT=9000

REPONAME="srinics"

DOCKERFILE_APP="./docker/dockerfile-db"
DOCKERFILE_DB="./docker/dockerfile-app"
IMAGE_NAME_DB="dproject-db-img"
IMAGE_NAME_APP="dproject-app-img"
CONTAINER_NAME_APP="dproject-app-cnt"
OP=$1


if [ "$OP" = "d" ]; then
	DEMONIZE=1
elif [ "$OP" = "c" ]; then
	CLEAN=1
fi

docker rmi $IMAGE_NAME_APP --force
docker rmi $IMAGE_NAME_DB --force
docker image prune --force
docker container prune --force
docker kill $CONTAINER_NAME_APP

if [ $CLEAN ]; then
	exit 0
fi


docker build $DOCKER_BUILD_OPTS -t $IMAGE_NAME_DB -f $DOCKERFILE_DB . || exit
docker build $DOCKER_BUILD_OPTS -t $IMAGE_NAME_APP -f $DOCKERFILE_APP . || exit

if [ $DEMONIZE ]; then
	docker run --name $CONTAINER_NAME_APP -p $HOST_PORT:$CONTAINER_PORT -itd --env http_proxy=$HTTP_PROXY --env https_proxy=$HTTPS_PROXY $IMAGE_NAME_APP || exit
else
	docker run --name $CONTAINER_NAME_APP -p $HOST_PORT:$CONTAINER_PORT -it --env http_proxy=$HTTP_PROXY --env https_proxy=$HTTPS_PROXY $IMAGE_NAME_APP || exit
fi

docker ps
