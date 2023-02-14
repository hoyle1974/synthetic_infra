#!/bin/bash

namespace=$1
pod=$2
kubectl exec --stdin --tty $pod -n $namespace -- /bin/bash
