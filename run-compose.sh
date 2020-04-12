#!/bin/bash
set -x
OP="i"
HUB=$2

if [ $HUB = "h" ]; then
	compose_file="./docker/docker-compose-global.yml"
else
	compose_file="./docker/docker-compose.yml"
fi

if [ "$OP" = "d" ]; then
	docker-compose -f $compose_file --project-dir=.  up -d 
elif [ "$OP" = "b" ]; then
	docker-compose -f $compose_file --project-dir=.  build 
elif [ "$OP" = "c" ]; then
	docker-compose -f $compose_file --project-dir=.  stop
	docker-compose -f $compose_file --project-dir=.  kill
elif [ "$OP" = "t" ]; then
 	curl http://localhost:9000/index	
fi

if [ "$OP" = "i" ]; then
	docker-compose -f $compose_file --project-dir=.  up
fi
exit 0

