#!/bin/bash

./istio.sh
./dashboard.sh
./prometheus.sh
./pingpong.sh
./gitea.sh
echo
echo "Now run this command after gitea starts: "
echo "	kubectl --namespace gitea port-forward --address=192.168.181.99 svc/gitea-http 3000"
echo
echo "Then mirror this repository: https://github.com/hoyle1974/synthetic_infra.git"
echo
