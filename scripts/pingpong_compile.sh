#!/bin/bash

set -x

container=$(buildah from docker.io/library/golang@sha256:d78cd58c598fa1f0c92046f61fde32d739781e036e3dc7ccf8fdb50129243dd8)
echo "Container: $container"
buildah copy $container "pingpong/*" .
buildah config --env GOPATH="" $container
buildah run $container go mod download
buildah run $container go build .
mountpoint=$(buildah mount $container)
echo "Mountpoint: $mountpoint"
echo "-----------------------"
buildah run $container pwd
buildah run $container find .
echo "-----------------------"
cp $mountpoint/go/pingpong ./bin
echo "-----------------------"
find .
buildah unmount $mountpoint
buildah rm $container
