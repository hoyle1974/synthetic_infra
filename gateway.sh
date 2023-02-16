#!/bin/bash


up() {
	kubectl create -f gateway.yaml
}

down() {
	kubectl delete -f gateway.yaml
}

. ./base.sh $1
