#!/bin/bash
OP=$1

if [ "$OP" = "d" ]; then
	docker-compose -f ./docker/docker-compose.yml --project-dir=.  -d up
elif [ "$OP" = "c" ]; then
	docker-compose -f ./docker/docker-compose.yml stop
	docker-compose -f ./docker/docker-compose.yml kill
elif [ "$OP" = "t" ]; then
 	curl http://localhost:9000/index	
fi

docker-compose -f ./docker/docker-compose.yml --project-dir=.  up
