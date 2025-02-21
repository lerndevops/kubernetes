## Step1: install ArgoCD Server
```sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
## Step2: Update Service Type to NodePort
```sh
kubectl -n argocd patch svc argocd-server -p '{"spec": {"type": "NodePort"}}'
```
## Step3: get initial admin password to login ArgoCD UI
```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d ; echo 
```
## Step4: login to ArgoCD UI
```sh
access with master/nodeIP:nodePort --> to access the Argo CD UI

username: admin

password: Output of Line Step3.
```