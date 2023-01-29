#!/bin/bash

up() {
	cd pingpong && docker build --tag ping . -f ./Dockerfile.ping ; cd ..
	cd pingpong && docker build --tag pong . -f ./Dockerfile.pong ; cd ..
	docker tag ping:latest k3d-myregistry.localhost:12345/ping:v1
	docker tag pong:latest k3d-myregistry.localhost:12345/pong:v1
	docker push k3d-myregistry.localhost:12345/ping:v1
	docker push k3d-myregistry.localhost:12345/pong:v1
	kubectl create -f ping.yaml
	kubectl create -f pong.yaml
	kubectl create -f pingpongmonitor.yaml
}

down() {
	kubectl delete -f pingpongmonitor.yaml
	kubectl delete -f ping.yaml
	kubectl delete -f pong.yaml
}

. ./base.sh $1

