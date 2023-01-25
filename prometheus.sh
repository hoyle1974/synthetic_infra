#!/bin/bash

up() {
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm install prom-operator-01 prometheus-community/kube-prometheus-stack

	kubectl create -f prometheus-rbac.yaml
	kubectl create -f prometheus.yaml
}

down() {
	kubectl delete -f prometheus.yaml
	kubectl delete -f prometheus-rbac.yaml

	helm uninstall prom-operator-01 

}

. ./base.sh $1
