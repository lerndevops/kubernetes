## get the K8S Server URL
```
root@kube-master:~# more /etc/kubernetes/admin.conf | grep server:
    server: https://192.168.198.147:6443
```

## create serviceaccount scoped to any namespace 
`kubectl create sa testuser -n kube-system`

## get the secret assciate with serviceaccount 
`kubectl describe sa testuser -n kube-system`
```
root@kube-master:~# kubectl describe sa testuser -n kube-system
Name:                testuser
Namespace:           kube-system
Labels:              <none>
Annotations:         <none>
Image pull secrets:  <none>
Mountable secrets:   `testuser-token-bg4xc`
Tokens:              `testuser-token-bg4xc`
Events:              <none>
```

## Token Value is our secrect

`kubectl describe secret testuser-token-bg4xc -n kube-system`

```
root@kube-master:~# kubectl describe secret testuser-token-bg4xc -n kube-system
Name:         testuser-token-bg4xc
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: testuser
              kubernetes.io/service-account.uid: a88e2e84-60cb-41d8-aa53-cb0ea4de3ebb

Type:  kubernetes.io/service-account-token

Data
====
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6Ik1fZF9rOEJMVmd3NFp2bUotSWVQdHZ6YlpEazk0TnBCOTVnMjJVQmlRTTAifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJ0ZXN0dXNlci10b2tlbi1iZzR4YyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJ0ZXN0dXNlciIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImE4OGUyZTg0LTYwY2ItNDFkOC1hYTUzLWNiMGVhNGRlM2ViYiIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlLXN5c3RlbTp0ZXN0dXNlciJ9.fxMihqmqk9GJ8VZ72w6g4Ppfrmnr4NYV6qo-WH_o9mFUYjntggMugJtF5SbocwXCIF5AXbyxYWFRye_Nr8vFYLRpcB9GT4FT3QXctp3zpm6pDYpW2aK4GpoM1wqksNbGeoibwhYHdaqsv7CIUfzYnwkYYOEP_AggLCrfp4h3Div_uQt-mlgp4ti_pq5ex-l4kH03kK6cIAHjP22CfdipIUwE_Xh5ssarQmiqq4iB8COq3W9tUIvsCYJBxgPsQk-fqoM9pfRqERBTUZM42GWO7ySHL4INQbUfm17pypeIW_F9K3awgVZS9oWbMeojV7BjEsFmMpR1ZPlI6ugwBZxJag
ca.crt:     1025 bytes
namespace:  11 bytes
```

#### as we can see above the screct is associated with ca.crt & a token, we can extract them and use in `config` file to connect to the cluster 

### Follow below to extract the values 
```
kubectl -n kube-system get secret/testuser-token-bg4xc -o jsonpath='{.data.ca\.crt}' > ca.crt
kubectl -n kube-system get secret/testuser-token-bg4xc -o jsonpath='{.data.token}' | base64 --decode > testuser.key
kubectl get secret/testuser-token-bg4xc -o jsonpath='{.data.namespace}' | base64 --decode
```

## create kube config file as below 

`replace the ca, token & server with content of ca.crt, testuser.key & server url accordingly`

vi testuser.conf

```
apiVersion: v1
kind: Config
clusters:
- name: kube-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: dev
  context:
    cluster: kube-cluster
    namespace: kube-system
    user: testuser
current-context: dev
users:
- name: testuser
  user:
    token: ${token}
```

## validate testuser able to authenticate with server 

```
root@kube-master:/home/devops/# kubectl --kubeconfig testuser.conf version --short
Client Version: v1.17.0
Server Version: v1.17.0
```

## validate testuser authorization 
```
root@kube-master:/home/devops/.kube# kubectl --kubeconfig testuser.conf get nodes
Error from server (Forbidden): nodes is forbidden: User "system:serviceaccount:kube-system:testuser" cannot list resource "nodes" in API group "" at the cluster scope
```

` the above Error is expected as we just authenticated with apiserver, but we haven't defined what testuser can perform ` 

## Role Based Access Control ( RBAC ) 

### define a Role -- what can be done 

```
	apiVersion: rbac.authorization.k8s.io/v1
	kind: Role
	metadata:
	namespace: kube-system
	name: readonly-role
	rules:
	- apiGroups: ["*"] # "" indicates the core API group
	resources: ["pods","deployments", "replicasets"]
	verbs: ["get", "watch", "list"]
	#verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
``` 

### define a rolebiding ( bind role to a user, gives the user set of permmissions )

```
	apiVersion: rbac.authorization.k8s.io/v1
	# This role binding allows "testuser" to read pods in the "kube-system" namespace.
	kind: RoleBinding
	metadata:
	name: readonly-binding
	namespace: kube-system
	subjects:
	- kind: ServiceAccount
	name: testuser # Name is case sensitive
	namespace: kube-system
	roleRef:
	kind: Role #this must be Role or ClusterRole
	name: readonly-role # this must match the name of the Role or ClusterRole you wish to bind to
	apiGroup: rbac.authorization.k8s.io
```

## validate able list deployments, pods replicasets 

```
root@kube-master:/home/devops/.kube# kubectl --kubeconfig testuser.conf get deploy
NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
calico-kube-controllers   1/1     1            1           3d19h
coredns                   2/2     2            2           3d19h
```
```
root@kube-master:/home/devops/.kube# kubectl --kubeconfig testuser.conf get rs
NAME                                 DESIRED   CURRENT   READY   AGE
calico-kube-controllers-778676476b   1         1         1       3d19h
coredns-6955765f44                   2         2         2       3d19h
```

