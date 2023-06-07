#!/bin/bash
echo "... Loading variables"
. ./variables.sh

echo ".................................................." 
echo ">>> Creating resources for [$INFRACODE] <<<"
echo ".................................................." 

echo "${DBG}... Create resource group [$RESOURCE_GROUP]"
az group create -l $LOCATION -n $RESOURCE_GROUP

echo "${DBG}... Creating AKS [$AKS_NAME]"
az aks create -g $RESOURCE_GROUP -n $AKS_NAME \
  --kubernetes-version "1.26.3" \
  --node-count 1 \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 3 \
  --enable-aad \
  --aad-admin-group-object-ids $AKS_AD_AKSADMIN_GROUP_ID \
  --aad-tenant-id $AZURE_AD_TENANTID \
  --enable-oidc-issuer \
  --enable-managed-identity \
  --enable-asm \
  --os-sku AzureLinux \
  --enable-workload-identity --generate-ssh-keys

echo "${DBG}... Script completed"

helm get manifest azure-service-mesh-istio-base -n kube-system

helm get manifest azure-service-mesh-istio-discovery -n aks-istio-system > istio-discovery.txt
