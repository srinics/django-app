#!/bin/bash
set -x 
#HTTP_PROXY="http://localproxy:12000/"
#HTTPS_PROXY="http://localproxy:12000/"
#DOCKER_BUILD_OPTS="--build-arg http_proxy=$HTTP_PROXY --build-arg https_proxy=$HTTPS_PROXY"

HOST_PORT_APP=9000
CONTAINER_PORT_APP=9000
HOST_PORT_DB=5432
CONTAINER_PORT_DB=5432

REPONAME="srinics"
TPATH="./docker/temp/"

ENV_FILE_DB="./docker/db.env"
DOCKERFILE_APP="./docker/dockerfile-app"
DOCKERFILE_DB="./docker/dockerfile-db"
IMAGE_NAME_DB="dproject-img-db"
IMAGE_NAME_APP="dproject-img-app"
CONTAINER_NAME_APP="dproject-cnt-app"
CONTAINER_NAME_DB="dproject-cnt-db"
OP=$1


if [ "$OP" = "d" ]; then
	DEMONIZE=1
elif [ "$OP" = "c" ]; then
	CLEAN=1
fi

waitport() {
	    while ! nc -z localhost $1 ; do sleep 1 ; done
}

docker stop $CONTAINER_NAME_DB
docker stop $CONTAINER_NAME_APP
docker rmi $IMAGE_NAME_APP --force
docker rmi $IMAGE_NAME_DB --force
docker image prune --force
docker container prune --force
docker kill $CONTAINER_NAME_DB
docker kill $CONTAINER_NAME_APP

if [ $CLEAN ]; then
	exit 0
fi

docker build $DOCKER_BUILD_OPTS -t $IMAGE_NAME_DB -f $DOCKERFILE_DB $TPATH || exit
docker build $DOCKER_BUILD_OPTS -t $IMAGE_NAME_APP -f $DOCKERFILE_APP . || exit

#CMD_PROXY="--env http_proxy=$HTTP_PROXY --env https_proxy=$HTTPS_PROXY"
CMD_DB="--name $CONTAINER_NAME_DB -p $HOST_PORT_DB:$CONTAINER_PORT_DB $CMD_PROXY --env-file $ENV_FILE_DB $IMAGE_NAME_DB"
CMD_APP="--name $CONTAINER_NAME_APP -p $HOST_PORT_APP:$CONTAINER_PORT_APP $CMD_PROXY --link $CONTAINER_NAME_DB:$CONTAINER_NAME_DB $IMAGE_NAME_APP"

if [ $DEMONIZE ]; then
	docker run -itd $CMD_DB || exit
	waitport $HOST_PORT_DB
	docker run -itd $CMD_APP || exit
else
	docker run -itd $CMD_DB || exit
	waitport $HOST_PORT_DB
	docker run -it $CMD_APP || exit
fi
docker ps
