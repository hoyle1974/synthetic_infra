#!/bin/bash

docker build . -f Dockerfile.kubectl -t kubectl
docker tag kubectl kubectl:latest

if [ "$1" == "deploy" ]
then
	docker tag kubectl jstrohm/gocd-agent-kubectl:latest
	docker push jstrohm/gocd-agent-kubectl:latest
fi
