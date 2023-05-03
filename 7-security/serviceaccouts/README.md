## Kubernetes Service Accounts

> Kubernetes offers distinct ways for clients authenticate to the API server.

> When you authenticate to the API server, you identify yourself as a particular user. Kubernetes recognises the concept of a user, however, Kubernetes itself does not have a User API.

> A service account provides an identity for processes that run in a Pod's containers, and maps to a ServiceAccount object. 

### Create ServiceAccount Scoped to any Namespace 

```
kubectl create sa testsa
kubectl get sa testsa
```

### Map ServiceAccount to Pod 
```
use the pod yaml below to create Pod with ServiceAccount mapped

vi sa-test-pod.yaml 

apiVersion: v1
kind: Pod
metadata:
  name: sa-test-pod
  labels:
    app: sa-test-pod
spec:
  restartPolicy: Always
  serviceAccountName: testsa
  containers:
   - name: sa-test-pod
     image: lerndevops/samples:netshoot
    
save & close the file 
 
kubectl create -f sa-test-pod.yaml
```

### Exec into the POD created 

```
kubectl exec -it sa-test-pod -- /bin/bash
```

## **——— inside pod ——-**

### validate the Service Account is Mounted with token 

```
mount | grep sec

tmpfs on /run/secrets/kubernetes.io/serviceaccount type tmpfs (ro,relatime,size=562756k)

cd /run/secrets/kubernetes.io/serviceaccount ; ls -l

lrwxrwxrwx    1 root     root            13 Feb  3 06:12 ca.crt -> ..data/ca.crt
lrwxrwxrwx    1 root     root            16 Feb  3 06:12 namespace -> ..data/namespace
lrwxrwxrwx    1 root     root            12 Feb  3 06:12 token -> ..data/token

cat token ; echo

eyJhbGciOiJSUzI1NiIsImtpZCI6ImQwMjhkNmVhMGVhNGRjMGMzYTllMTMzY2M2OTcxMDdhMWNlNWQ1MTQifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjIl0sImV4cCI
6MTcwNjk0MDc0NywiaWF0IjoxNjc1NDA0NzQ3LCJpc3MiOiJodHRwczovL29pZGMuZWtzLnVzLWVhc3QtMi5hbWF6b25hd3MuY29tL2lkLzAwMTBDNkIzMDgwNzMxMjI4RjVEOURERDg1RDBGMENEIi
wia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJkZWZhdWx0IiwicG9kIjp7Im5hbWUiOiJzYS10ZXN0LXBvZCIsInVpZCI6IjVhMjEwYTQxLTYyYTMtNDVkNS1iODdlLTU1MzI2ZmRjZGYwMyJ9L
CJzZXJ2aWNlYWNjb3VudCI6eyJuYW1lIjoidGVzdHNhIiwidWlkIjoiYzg2Y2JiZjQtZjUyNC00YWE1LWI3OGMtMWVjNDNlMTI5ZDBjIn0sIndhcm5hZnRlciI6MTY3NTQwODM1NH0sIm5iZiI6M
TY3NTQwNDc0Nywic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmRlZmF1bHQ6dGVzdHNhIn0.ZhH---9KWMHqVh1qXdajvSFa58-Q3FEsLL4wTrHCn9cxoNQy07fW6ROG625x7RQAAh4O8iOpCHH
0kzUssbIttOqi2kseby_wy04PbInHPvjos5U0a75Z2Dtzo48mQlCtmnHAS4JSXxrWPVZvuAEN4QIeC4du6RlsYT_0BdgPHjDzpw6ufnZsh_IiOkR4cepXIns2hanY33Nz3NpOloIaPeDsBw2oW
vi2k_AnOIqQ5izjD1Sqyq1qgERYCGPOKPz9s_OPryDsXuGbLdkX32tD2j5-UOLP3sGpzI7NFXJjeLTRVWNFaYSkngZCrDEOgkIp1KF3PIbBqBMG7eGobqgW5g
```

### send a request as anonymous 

> **Note: `"kubernetes"` is the deafult service under default namespace that points to APIServer always in any kube cluster**

```
curl https://kubernetes.default.svc -k

{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "forbidden: User \"system:anonymous\" cannot get path \"/\"",
  "reason": "Forbidden",
  "details": {},
  "code": 403
}
```
### As we see above the request to the API sent as anonymous user 

### Lets send a request to API Server with the service account token 

```
bash-5.1# curl https://kubernetes.default.svc -k -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImQwMjhkNmVhMGVhNGRjMGMz-Q3FEsLL4wTr...."

{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "forbidden: User \"system:serviceaccount:default:testsa\" cannot get path \"/\"",
  "reason": "Forbidden",
  "details": {},
  "code": 403
}
``` 

```
curl https://kubernetes.default.svc/api/v1/namespaces/default/pods -k -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImQwMjhkNmVhMGVhNG..."

{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "pods is forbidden: User \"system:serviceaccount:default:testsa\" cannot list resource \"pods\" in API group \"\" in the namespace \"default\"",
  "reason": "Forbidden",
  "details": {
    "kind": "pods"
  },
  "code": 403
}

```
### we can now see the Service Account testsa sent a request successfully, but it is not authorized to perform the actions

### `Logout of the Pod - exit`

## Service Account Authorization to API Server 

> kubernetes APIServer Uses internal RABC implentation to provide the fine grained access for all the clients including client that pods that Use Service Accounts 

### For Namespace Scoped Access, we assing the Service Account to role using rolebinding as below

```
# create role scoped to default namespace with read permissions
kubectl create role testsa-role --namespace=default --verb=get,list,watch --resource="*.*"

# assing the role to Service Account 
kubectl create rolebinding testsa-rb --namespace=default --role=testsa-role --serviceaccount=default:testsa

```
### For Cluster Level Access, we assign the Service Account to clusterrole using clusterrolebinding as below 
```
# create clusterrole with read permissions
kubectl create clusterrole testsa-cr --verb=get,list,watch --resource="*.*"

# assing the clusterrole to Service Account 
kubectl create clusterrolebinding testsa-crb --clusterrole=testsa-cr --serviceaccount=default:testsa
```
