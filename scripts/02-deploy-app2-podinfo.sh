#!/bin/bash
echo "... Loading variables"
. ./variables.sh

export NS="pinfo2"

echo "${DBG}... create namespace [$NS]"
kubectl create namespace $NS

echo "${DBG}... deploy podinfo on namespace [$NS]"

helm repo add podinfo https://stefanprodan.github.io/podinfo

helm upgrade --install --wait frontend --namespace $NS --set replicaCount=2 --set backend=http://backend-podinfo:9898/echo podinfo/podinfo

helm test frontend --namespace $NS

helm upgrade --install --wait backend --namespace $NS --set redis.enabled=true podinfo/podinfo


echo "${DBG}... deploy debug pod on ns [$NS]"
kubectl apply -f ../k8s/curl.yaml -n $NS

helm list -A

# helm uninstall frontend -n $NS

# helm uninstall backend -n $NS


