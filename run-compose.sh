#!/bin/bash
set -x
OP=$1

if [ "$OP" = "d" ]; then
	docker-compose -f ./docker/docker-compose.yml --project-dir=.  up -d 
elif [ "$OP" = "c" ]; then
	docker-compose -f ./docker/docker-compose.yml --project-dir=.  stop
	docker-compose -f ./docker/docker-compose.yml --project-dir=.  kill
elif [ "$OP" = "t" ]; then
 	curl http://localhost:9000/index	
fi

if [ -z "$OP" ]; then
	docker-compose -f ./docker/docker-compose.yml --project-dir=.  up
fi
exit 0

