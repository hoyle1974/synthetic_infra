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


	ip=`hostname -I | awk '{print $1}'`
	echo "Prometheus expose: kubectl port-forward --address=$ip svc/prometheus-operated 9090:9090 -n monotiring"
	echo "Grafana expose: kubectl port-forward --address=$ip svc/grafana 3000 -n monitoring"
	echo "	Grafana user/pass is admin/admin"
}

down() {
	get_operator
	cd kube-prometheus-main
	kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup
	cd ..
}

. ./base.sh $1
