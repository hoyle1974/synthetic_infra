#!/bin/bash

pod=`kubectl get pods -n istio-system -l app=istio-ingressgateway -o=jsonpath='{.items[0].metadata.name}'`

istioctl proxy-config log {$pod}.istio-system --level debug
kubectl -n istio-system logs $pod istio-proxy  -f
