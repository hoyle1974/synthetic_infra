#!/bin/bash

# Used this to style on: https://www.knowledgehut.com/blog/devops/private-docker-registry

up() {
	helm repo add twuni https://helm.twun.io
	helm install docker-registry twuni/docker-registry -f registry-values.yaml
	kubectl create -f registry.yaml

	#wait_for_pod default docker-registry-pod
}

down() {
	kubectl delete -f registry.yaml
	helm uninstall docker-registry
}

. ./base.sh $1


