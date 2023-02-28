#!/bin/bash

up() {
	htpasswd -Bbn admin admin > htpasswd
	kubectl create configmap registry-auth --from-file=htpasswd
	kubectl create secret docker-registry myregistrykey --docker-server=registry.gunsmoke.local --docker-username=admin --docker-password=admin --docker-email=hoyle.hoyle@gmail.com 
	openssl req -x509 -newkey rsa:4096 -days 365 -nodes -sha256 -keyout tls.key -out tls.crt -subj "/CN=registry.gunsmoke.local"  \
    		-reqexts SAN \
		-extensions SAN \
    		-config <(cat /etc/ssl/openssl.cnf \
        		<(printf "\n[SAN]\nsubjectAltName=DNS:registry.gunsmoke.local,DNS:registry.default.svc.cluster.local")) 
	openssl rsa -in ./tls.key -text > rootCA.pem
	pem=`base64 -i rootCA.pem`
	kubectl create secret generic registry-certs --from-file=tls.crt=./tls.crt --from-file=tls.key=./tls.key


	kubectl create -f registry.yaml
}

down() {
	kubectl delete -f registry.yaml
	kubectl delete configmap registry-auth
	kubectl delete secret myregistrykey
	kubectl delete secret registry-certs
}

. ./base.sh $1


