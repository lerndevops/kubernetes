#!/bin/bash

#Generate the pod yaml with below command
kubectl run --generator=run-pod/v1 nginx --image=nginx -o yaml --dry-run > nginx.yaml

#Generate deployment yaml with below command
kubectl create deploy nginx --image=nginx --dry-run -o yaml > nginx-deploy.yaml

kubectl create configmap nginx --dry-run -o yaml > nginx-cm.yaml

#Generate service yaml with below command
kubectl expose pod hello-pod --type=NodePort --name=pod-svc --dry-run > pod-svc.yaml
kubectl expose deployment hello-deploy --type=NodePort --name=deploy-svc --dry-run > deploy-svc.yaml
