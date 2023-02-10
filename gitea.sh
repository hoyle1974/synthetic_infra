#!/bin/bash

up() {
	helm repo add gitea-charts https://dl.gitea.io/charts/
	helm repo update
	kubectl create namespace gitea
	helm install gitea gitea-charts/gitea -f gitea-values.yaml -n gitea
	kubectl create -f gitea-sm.yaml #-n gitea
}

down() {
	helm uninstall gitea -n gitea
	kubectl delete -f gitea-sm.yaml #-n gitea
	kubectl delete namespace gitea
}

. ./base.sh $1


