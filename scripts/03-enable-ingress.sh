#!/bin/bash
echo "... Loading variables"
. ./variables.sh

echo "${DBG}... enable ingress on [$AKS_NAME]"
az aks mesh enable-ingress-gateway --resource-group $RESOURCE_GROUP --name $AKS_NAME --ingress-gateway-type external

echo "${DBG}... helm  [$AKS_NAME]"
helm get manifest asm-igx-aks-istio-ingressgateway-external -n aks-istio-ingress > istio-ingress.txt

