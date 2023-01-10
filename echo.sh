#!/bin/bash

up() {
	kubectl create -f echo.yaml
}

down() {
	kubectl delete -f echo.yaml
}

. ./base.sh $1


