#!/bin/bash

up() {
	helm repo add gocd https://gocd.github.io/helm-chart
	helm repo update

	kubectl create namespace gocd
	kubectl label namespace gocd istio-injection=enabled
	helm install gocd gocd/gocd --namespace gocd -f gocd-values.yaml
	kubectl create -f gocd.yaml

	wait_for_app gocd gocd
}

down() {
	kubectl delete -f gocd.yaml
	helm uninstall gocd -n gocd
	kubectl delete namespace gocd
}

. ./base.sh $1


