#!/bin/bash


up() {
	#helm install --namespace istio-system --set auth.strategy="anonymous" --repo https://kiali.org/helm-charts kiali-server kiali-server
	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.17/samples/addons/kiali.yaml

	echo "Try: 	kubectl port-forward svc/kiali 20001:20001 -n istio-system --address=192.168.181.99"
}

down() {
	kubectl delete -f https://raw.githubusercontent.com/istio/istio/release-1.17/samples/addons/kiali.yaml
}

. ./base.sh $1
