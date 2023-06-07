# aks-istio-addon

Explore the Istio AddOn for AKS

## Step 0 - Install prerequisites

```
sh ./00-prerequisites.sh
```

## Step 1 - Create a public AKS cluster

Create a basic AKS cluster

```
sh ./01-create-aks.sh

kubectl get all -n aks-istio-system

```

## Step 2 - Create a demo application

deploy podinfo

Create the podinfo application in the 'pinfo1' namespace

```
sh ./02-deploy-app1-podinfo.sh
```

curl from a debug pod

```
kubectl exec -it curl-pod -n pinfo1 -- sh

curl -k http://backend-podinfo.pinfo1.svc.cluster.local:9898/
```

frontend

```
kubectl -n pinfo1 port-forward deploy/frontend-podinfo 8080:9898
```

## Step 3 - Enable the istio ingress

```
sh ./03-enable-ingress.sh
```

## Step 4 - Deploy Gateway and VirtualService

```
sh ./04-config-ingress-app1.sh
```

Test the frontend application at the following address

http://pinfo1.20.13.64.179.nip.io/


# Other

Install kubectl and kubelogin if not present yet

```
sudo az aks install-cli --only-show-errors
```

Install IstioCtl
```
curl -sL https://istio.io/downloadIstioctl | sh -

az login --use-device-code

istioctl dashboard zipkin -n aks-istio-system
```

```
kubectl label namespace bookinfo istio.io/rev=asm-1-17
kubectl apply -f ../k8s/bookinfo.yaml -n bookinfo
```
