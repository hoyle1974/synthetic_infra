#!/bin/bash

up() {
	istioctl install --set profile=default -y
	kubectl label namespace default istio-injection=enabled
}

down() {
	istioctl uninstall --purge -y
}

. ./base.sh $1
