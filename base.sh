#!/bin/bash

wait_for_pod() {
	c=0
	echo -n "Waiting for $1/$2 to be running"
	while [[ $(kubectl get -n $1 pods $2 -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
		if [ $c == 0  ]
		then
			echo -n "."
		fi
		sleep 1
		c=$(( $c + 1 ))
		if [ $c -gt 5  ]
		then 
			c=0
		fi

	done
	echo "$1/$2 is now running."
}

wait_for_app() {
	kubectl wait pods -n $1 -l app=$2 --for condition=Ready --timeout=600s
	echo "$1/$2 is now running."
}

if [[ "$1" = "up" || -z "$1" ]]; then
	echo "----- UP -----"
	up
	return
fi

if [ "$1" = "down" ]
then
	echo "----- DOWN -----"
	down
	return
fi

if [ "$1" = "restart" ]
then
	echo "----- DOWN -----"
	down
	echo "----- UP -----"
	up
	return
fi

echo "Invalid argument: $1"
