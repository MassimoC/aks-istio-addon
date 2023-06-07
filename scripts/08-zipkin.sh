#!/bin/bash
echo "... Loading variables"
. ./variables.sh

echo "${DBG}... deploy zipkin"
kubectl apply -f ../k8s/zipkin.yaml

kubectl apply -f ../k8s/telemetry-ns.yaml