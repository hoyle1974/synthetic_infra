#!/bin/bash

echo "pausing . . ."
docker pause `docker ps | cut -f1 -d' ' | grep -v CONTAINER`
