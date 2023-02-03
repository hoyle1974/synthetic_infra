#!/bin/bash

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
