#!/bin/bash

get_operator() {
	if [ ! -d ./kube-prometheus-main ]
	then
		wget https://github.com/prometheus-operator/kube-prometheus/archive/main.zip
		unzip main.zip
		rm main.zip
	else
		echo "kube-prometheus-main already downloaded"
	fi
}

up() {
	get_operator

	cd kube-prometheus-main
	kubectl create -f manifests/setup
	until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo "waiting"; done
	kubectl create -f manifests/
	cd ..
	kubectl patch service prometheus-operated -n monitoring --patch-file prometheus-operated-patch.yaml
	kubectl patch service prometheus-k8s -n monitoring --patch-file prometheus-operated-patch.yaml
	kubectl label namespace monitoring istio-injection=enabled
	kubectl rollout restart deployment prometheus-operator -n monitoring
	kubectl rollout restart deployment grafana -n monitoring
	kubectl rollout restart deployment blackbox-exporter -n monitoring
	kubectl rollout restart deployment kube-state-metrics -n monitoring
	kubectl rollout restart deployment prometheus-adapter -n monitoring
	kubectl create -f prometheus.yaml


	ip=`hostname -I | awk '{print $1}'`
	echo "Prometheus expose: kubectl port-forward --address=$ip svc/prometheus-operated 9090:9090 -n monitoring"
	echo "Grafana expose: kubectl port-forward --address=$ip svc/grafana 3000 -n monitoring"
	echo "	Grafana user/pass is admin/admin"
}

down() {
	get_operator
	cd kube-prometheus-main
	kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup
	cd ..
	kubectl delete -f prometheus.yaml
}

. ./base.sh $1
