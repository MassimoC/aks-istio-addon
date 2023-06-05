
echo "${DBG}... deploy istio gateway and virtual-service for pinfo on namespace [$NS]"

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
   - '$NS.20.13.64.179.nip.io'
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
 name: virtual-pinfo
 namespace: $NS
spec:
 hosts:
   - "$NS.20.13.64.179.nip.io"
 gateways:
   - $NS/istio-ingress-$NS
 http:
 - match:
   - uri:
       prefix: "/"
   route:
   - destination:
       host: "backend-podinfo.$NS.svc.cluster.local"
       port:
         number: 9898
EOF
