#!/bin/bash

up() {
	helm repo add gocd https://gocd.github.io/helm-chart
	helm repo update

	kubectl create namespace gocd
	helm install gocd gocd/gocd --namespace gocd

	wait_for_app gocd gocd
}

down() {
	helm uninstall gocd -n gocd
	kubectl delete namespace gocd
}

. ./base.sh $1


