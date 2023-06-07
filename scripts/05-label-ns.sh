#!/bin/bash
echo "... Loading variables"
. ./variables.sh

export NS="pinfo2"
echo "${DBG}... create namespace [$NS]"
kubectl create namespace $NS

echo "${DBG}... label the namespace for istio asm [$NS]"
kubectl label namespace $NS istio.io/rev=asm-1-17
