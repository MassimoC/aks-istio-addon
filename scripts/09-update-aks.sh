#!/bin/bash
echo "... Loading variables"
. ./variables.sh

echo ".................................................." 
echo ">>> updating [$AKS_NAME] <<<"
echo ".................................................." 

# https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/azure-monitor-workspace-manage?tabs=cli
az resource create --resource-group $RESOURCE_GROUP \
  --namespace microsoft.monitor \
  --resource-type accounts \
  --name $WORKSPACE_NAME \
  --location $LOCATION --properties {}

echo "${DBG}... Create log analytics workspace [$LOG_ANALYTICS_WORKSPACE]"
LAW_ID=$(az monitor log-analytics workspace create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --workspace-name "$LOG_ANALYTICS_WORKSPACE" | jq -r '.id')

# https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-enable-aks?tabs=azure-cli
az aks enable-addons -a monitoring -n $AKS_NAME -g $RESOURCE_GROUP --workspace-resource-id $LAW_ID

# https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/prometheus-metrics-enable?tabs=cli
az aks update --enable-azure-monitor-metrics -n $AKS_NAME -g $RESOURCE_GROUP --azure-monitor-workspace-resource-id $WORKSPACE_ID
