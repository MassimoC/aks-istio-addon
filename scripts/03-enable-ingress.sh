#!/bin/bash
echo "... Loading variables"
. ./variables.sh

echo "${DBG}... enable ingress on [$AKS_NAME]"
az aks mesh enable-ingress-gateway --resource-group $RESOURCE_GROUP --name $AKS_NAME --ingress-gateway-type external
