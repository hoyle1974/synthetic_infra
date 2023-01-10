#!/bin/bash

up() {

	# Install kube dashboard
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
	kubectl create -f dashboard/kube-dashboard.yaml
	kubectl create -f dashboard/kube-dashboard-clusterrolebinding.yaml

	echo
	echo "To create a token for logging into the dashboard, run this:"
	echo "	kubectl -n kubernetes-dashboard create token admin-user "
	echo 
	echo "and then try: "
	echo "	kubectl proxy"
	echo
	echo "then go to: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
	echo
}

down() {
	kubectl delete -f dashboard/kube-dashboard-clusterrolebinding.yaml
	kubectl delete -f dashboard/kube-dashboard.yaml
	kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
}

. ./base.sh $1
