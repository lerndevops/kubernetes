kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl get svc -n argocd
 
kubectl edit svc argocd-server -n argocd

##replace ClusterIP with NodePort

kubectl get svc -n argocd

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d


access with master/nodeIP: nodePort --> to access the Argo CD UI

username: admin

password: Output of Line 13 above.
