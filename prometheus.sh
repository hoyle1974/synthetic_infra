#!/bin/bash

up() {
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm install prom-operator-01 prometheus-community/kube-prometheus-stack --version 35.0.0

	kubectl create -f prometheus-rbac.yaml
	kubectl create -f prometheus.yaml

	echo "Admin User: `kubectl get secret prom-operator-01-grafana -o jsonpath="{.data.admin-user}" | base64 --decode`"
	echo "Password: `kubectl get secret prom-operator-01-grafana -o jsonpath="{.data.admin-password}" | base64 --decode`"

	ip=`hostname -I | awk '{print $1}'`
	echo "Prometheus expose: kubectl port-forward --address=$ip svc/prometheus-operated 9090:9090"
	echo "Grafana expose: kubectl port-forward --address=$ip svc/prom-operator-01-grafana 8080:80"
}

down() {
	kubectl delete -f prometheus.yaml
	kubectl delete -f prometheus-rbac.yaml

	helm uninstall prom-operator-01 

}

. ./base.sh $1
