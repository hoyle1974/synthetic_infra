#!/bin/bash

while [ true ] 
do
	kubectl get all -n $1 > /tmp/out.txt
	clear
	cat /tmp/out.txt
	sleep 5
done
