#!/bin/bash

up() {
	k3d registry create myregistry.localhost --port 12345
 	k3d cluster create --servers 1 --agents 0 --port 9080:80@loadbalancer --port 9443:443@loadbalancer --api-port 6443 --k3s-arg "--disable=traefik@server:0" --registry-use k3d-myregistry.localhost:12345
	sleep 5

	echo -n "Waiting for metrics server . . ."
	kubectl wait pods -n kube-system -l k8s-app=metrics-server --for condition=Ready --timeout=600s
	echo -n "Waiting for kube dns . . ."
	kubectl wait pods -n kube-system -l k8s-app=kube-dns --for condition=Ready --timeout=600s
	echo -n "Waiting for local path provisioner . . ."
	kubectl wait pods -n kube-system -l app=local-path-provisioner --for condition=Ready --timeout=600s
	echo "Kubernetes is available"
}

down() {
	k3d cluster stop k3s-default
	k3d cluster delete k3s-default
	k3d registry delete myregistry.localhost
	docker image prune -af
}

. ./base.sh $1


