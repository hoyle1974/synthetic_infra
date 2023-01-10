#!/bin/bash

if [[ "$1" = "up" || -z "$1" ]]; then
	echo "----- UP -----"
	up
fi

if [ "$1" = "down" ]
then
	echo "----- DOWN -----"
	down
fi
