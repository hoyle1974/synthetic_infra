#!/bin/bash

pod=`kubectl get pods -n istio-system -l app=istio-ingressgateway -o=jsonpath='{.items[0].metadata.name}'`

if [[ "$1" = "debug" || -z "$1" ]]; then
	level=debug
else
	level=$1
fi

istioctl proxy-config log ${pod}.istio-system --level $level
kubectl -n istio-system logs $pod istio-proxy  -f
