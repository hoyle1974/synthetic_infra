#!/bin/bash

up() {
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm install prom-operator-01 prometheus-community/kube-prometheus-stack

	kubectl create -f prometheus-rbac.yaml
	kubectl create -f prometheus.yaml
	kubectl create -f podmonitor.yaml
}

down() {
	kubectl delete -f podmonitor.yaml
	kubectl delete -f prometheus.yaml
	kubectl delete -f prometheus-rbac.yaml

	helm uninstall prom-operator-01 prometheus-community/kube-prometheus-stack

}

. ./base.sh $1
