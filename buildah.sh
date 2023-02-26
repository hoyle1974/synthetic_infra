#!/bin/bash

docker build . -f Dockerfile.buildah -t buildah
docker tag buildah registry.gunsmoke.local:31468/buildah
docker push registry.gunsmoke.local:31468/buildah
