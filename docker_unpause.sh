#!/bin/bash

echo "Unpausing . . ."
docker unpause `docker ps | cut -f1 -d' ' | grep -v CONTAINER`
