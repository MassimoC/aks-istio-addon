#!/bin/bash
echo "... Loading variables"
. ./variables.sh

export NS="bookinfo"
LB_IP=$(kubectl -n kube-system get svc aks-istio-ingressgateway-external -n aks-istio-ingress -o json | jq -r .status.loadBalancer.ingress[0].ip)

echo "${DBG}... deploy istio gateway and virtual-service for bookinfo on namespace [$NS]"

kubectl apply -f - <<EOF
---
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
 name: istio-ingress-$NS
 namespace: $NS
spec:
 selector:
   istio: aks-istio-ingressgateway-external
 servers:
 - port:
     number: 80
     name: http
     protocol: HTTP
   hosts:
   - '$NS.$LB_IP.nip.io'
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
 name: virtual-pinfo
 namespace: $NS
spec:
 hosts:
   - "$NS.$LB_IP.nip.io"
 gateways:
   - $NS/istio-ingress-$NS
 http:
 - match:
   - uri:
       prefix: "/productpage"
   - uri:
       prefix: /static
   - uri:
       prefix: /login
   - uri:
       prefix: /logout
   - uri:
       prefix: /api/v1/products
   route:
   - destination:
       host: "productpage.$NS.svc.cluster.local"
       port:
         number: 9080
EOF
