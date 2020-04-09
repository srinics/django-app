#!/bin/bash
HTTP_PROXY="http://localproxy:12000/"
HTTPS_PROXY="http://localproxy:12000/"
#DOCKER_BUILD_OPTS="--build-arg http_proxy=$HTTP_PROXY --build-arg https_proxy=$HTTPS_PROXY"

HOST_PORT=9000
CONTAINER_PORT=9000

REPONAME="srinics"

DB_IMAGE_NAME="postgres"
IMAGE_NAME="django-project-img"
CONTAINER_NAME="django-project-cnt"
OP=$1


if [ "$OP" = "d" ]; then
	DEMONIZE=1
elif [ "$OP" = "c" ]; then
	CLEAN=1
fi

docker rmi $IMAGE_NAME --force
docker rmi $DB_IMAGE_NAME --force
docker image prune --force
docker container prune --force
docker kill $CONTAINER_NAME

if [ $CLEAN ]; then
	exit 0
fi

docker build $DOCKER_BUILD_OPTS -t $IMAGE_NAME . || exit

if [ $DEMONIZE ]; then
	docker run --name $CONTAINER_NAME -p $HOST_PORT:$CONTAINER_PORT -itd --env http_proxy=$HTTP_PROXY --env https_proxy=$HTTPS_PROXY $IMAGE_NAME || exit
else
	docker run --name $CONTAINER_NAME -p $HOST_PORT:$CONTAINER_PORT -it --env http_proxy=$HTTP_PROXY --env https_proxy=$HTTPS_PROXY $IMAGE_NAME || exit
fi

docker ps
