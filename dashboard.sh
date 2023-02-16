#!/bin/bash

up() {

	# Install kube dashboard
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
	kubectl label namespace kubernetes-dashboard istio-injection=enabled
	kubectl create -f dashboard.yaml
	kubectl patch service kubernetes-dashboard -n kubernetes-dashboard --patch-file dashboard-patch-dashboard-service.yaml
	kubectl patch service dashboard-metrics-scraper -n kubernetes-dashboard --patch-file dashboard-patch-metrics-service.yaml

	kubectl rollout restart deployment kubernetes-dashboard -n kubernetes-dashboard
	kubectl rollout restart deployment dashboard-metrics-scraper -n kubernetes-dashboard

	sleep 3


	echo -n "Waiting for dashboard metrics server . . ."
	kubectl wait pods -n kubernetes-dashboard -l k8s-app=dashboard-metrics-scraper --for condition=Ready --timeout=600s
	echo -n "Waiting for kubernetes dashboard . . ."
	kubectl wait pods -n kubernetes-dashboard -l k8s-app=kubernetes-dashboard --for condition=Ready --timeout=600s

	echo
	echo "To create a token for logging into the dashboard, run this:"
	echo "	kubectl -n kubernetes-dashboard create token admin-user "
	echo 
	echo "and then try: "
	echo "	kubectl proxy"
	echo
	echo "then go to: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
	echo
	echo "If you have this on a remote machine try creating a DNS entry to that machine for: dashboard.example.com"
	echo "and then try: "
	echo
	echo "https://gunsmoke.local:9443/#/login"
}

down() {
	kubectl delete -f dashboard.yaml
	kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
}

. ./base.sh $1
