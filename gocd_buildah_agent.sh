#!/bin/bash

docker build . -f Dockerfile.buildah -t buildah
docker tag buildah buildah:latest

if [ "$1" == "deploy" ]
then
	docker tag buildah jstrohm/gocd-agent-buildah:latest
	docker push jstrohm/gocd-agent-buildah:latest
fi
