#!/bin/bash

up() {
	k3d registry create myregistry.localhost --port 12345
 	k3d cluster create --servers 1 --agents 0 --port 9080:80@loadbalancer --port 9443:443@loadbalancer --api-port 6443 --k3s-arg "--disable=traefik@server:0" --registry-use k3d-myregistry.localhost:12345
}

down() {
	k3d cluster stop k3s-default
	k3d cluster delete k3s-default
}

. ./base.sh $1


