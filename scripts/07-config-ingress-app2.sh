#!/bin/bash
echo "... Loading variables"
. ./variables.sh

export NS="pinfo2"
LB_IP=$(kubectl -n kube-system get svc aks-istio-ingressgateway-external -n aks-istio-ingress -o json | jq -r .status.loadBalancer.ingress[0].ip)

. ./04-config-ingress.sh