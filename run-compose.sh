#!/bin/bash
set -x
OP="$1"
HUB=$2

compose_file="./docker/docker-compose.yml"

if [ "$OP" = "d" ]; then
	docker-compose -f $compose_file --project-dir=.  up -d 
elif [ "$OP" = "b" ]; then
	docker-compose -f $compose_file --project-dir=.  build 
elif [ "$OP" = "c" ]; then
	docker-compose -f $compose_file --project-dir=.  stop
	docker-compose -f $compose_file --project-dir=.  kill
elif [ "$OP" = "t" ]; then
 	curl http://localhost:9090/index	
fi

if [ -z "$OP" ]; then
	docker-compose -f $compose_file --project-dir=.  up
fi
exit 0

