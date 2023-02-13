#!/bin/bash


up() {
	helm repo add gitea-charts https://dl.gitea.io/charts/
	helm repo update
	kubectl create namespace gitea
	helm install gitea gitea-charts/gitea -f gitea-values.yaml -n gitea
	kubectl create -f gitea-sm.yaml 

	wait_for_pod gitea gitea-0
}

down() {
	helm uninstall gitea -n gitea
	kubectl delete -f gitea-sm.yaml 
	kubectl delete namespace gitea
}

. ./base.sh $1


