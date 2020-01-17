# deploy insecure dashboard
```
   kubectl apply -f dashboard-v2-insecure.yml
```
### validate
```
   ensure dashboard deployment is available & pod in running state

       kubectl get deploy -n kubernetes-dashboard
       kubectl get pods -n kubernetes-dashboard
```
### Access UI
```
   kubectl get svc -n kubernetes-dashboard ( note port number ex: 30605)
   
   open the broser and hit -- http://ip:port  (if deployed in aws use publicip)
      ex: http://3.14.249.66:30605/
   
   skip the login to get in !!     
```

# deploy Secure dashboard

```
   kubectl apply -f dashboard-v2-secure.yml
```

### Create Service Account & Get token to login to UI
```
kubectl create serviceaccount dashboard-sa
kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=default:dashboard-sa
kubectl get secret $(kubectl get serviceaccount dashboard-sa -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode
```

***Note: the token looks like below, copy it carefully, this will be the login credential for the UI we use.***

```
root@kube-master:~# kubectl get secret $(kubectl get serviceaccount dashboard-sa -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode
eyJhbGciOiJSUzI1NiIsImtpZCI6IjJBNzB4bFZDbFN1cVRkd3N4VkxSVTdmVS1ROGlyR2l5WVl4ZHZ0UVkyNHcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRhc2hib2FyZC1zYS10b2tlbi16YjJ3cSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJkYXNoYm9hcmQtc2EiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI2MjJkZDhhMC02ZjBlLTQyMzAtYmRmNy1iY2UzM2I1MGRmYjkiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6ZGVmYXVsdDpkYXNoYm9hcmQtc2EifQ.MrkHfl7zvAT7u7xb2eCcSmJZL6ieJlO7AcK2ho_GxslAYCzLHI8jubynoBXADqhHf6H4ej4beXJNjrMTmqWdGE11reGm9WOtoYs_R4kCoAExMVNcSXqKYjfcRbRIYPh7jprVjwkW9h2lqtAW5L2w-941jshuwVN9prxD-Vx-2mNwehjSqpyw5fEjAPkh5Kn-GF7e00Ce4EPMXeUzIM28f8liZ7LY oL9sfiKXICx5Z8Z92NmOPvjnmjpR7_8hfj7BfZVcEpGnpfbYdGx2NAZJbvncY-LfZ5AEOmRUGaanl8UFCeYVI0iYhpKBrOhMM8dzH57j96GV0ER_9kdzIEypw
```

### Get the Service & Node Port of dashbaord 

```
root@kube-master:~# kubectl get svc kubernetes-dashboard -n kubernetes-dashboard
NAME                   TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)         AGE
kubernetes-dashboard   NodePort   10.96.56.222   <none>        443:31003/TCP   5m54s
```

### Access UI

```
      open the browser and hit -- https://ip:port  (if deployed in aws use publicip)
      ex: https://3.14.249.66:30605/
   
   enter the token to login to the console !!     
```
