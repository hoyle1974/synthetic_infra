#!/bin/bash

up() {
	docker build --tag ping . -f ./Dockerfile.ping 
	docker build --tag pong . -f ./Dockerfile.pong 
	docker tag ping:latest k3d-myregistry.localhost:12345/ping:v1
	docker tag pong:latest k3d-myregistry.localhost:12345/pong:v1
	docker push k3d-myregistry.localhost:12345/ping:v1
	docker push k3d-myregistry.localhost:12345/pong:v1
	kubectl create -f ping.yaml
	kubectl create -f pong.yaml
}

down() {
	kubectl delete -f ping.yaml
	kubectl delete -f pong.yaml
}

. ./base.sh $1


