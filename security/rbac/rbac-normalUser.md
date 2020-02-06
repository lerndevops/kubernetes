# Setting up RBAC for Normal User 

### Step1: create a namespace 

```
root@kube-master:/home/devops/.kube# kubectl create ns prod
namespace/prod created
```
### Setp2: create a user prod-user

```
mkdir -p /home/prod-user/certs
cd /home/prod-user/certs
```

### Setp3: Create The User Credentials

> Kubernetes does not have API Objects for User Accounts. Of the available ways to manage authentication. we will use OpenSSL certificates for their simplicity. 

#### The necessary steps are:

* Create a private key for your user. In this example, we will name the file prod-user.key:

   `openssl genrsa -out prod-user.key 2048`
   
   ```
   root@kube-master:/home/prod-user/certs# openssl genrsa -out prod-user.key 2048
   Generating RSA private key, 2048 bit long modulus (2 primes)
   ........................+++++
   .................+++++
   e is 65537 (0x010001)
   ```

* Create a certificate sign request `prod-user.csr` using the private key we just created (prod-user.key in this example). Make sure you specify your username and group in the -subj section (CN is for the username and O for the group).

   `openssl req -new -key prod-user.key -out prod-user.csr -subj "/CN=prod-user/O=devops"`
   
* Locate Kubernetes cluster certificate authority (CA). This will be responsible for approving the request and generating the necessary certificate to access the cluster API. Its location is normally /etc/kubernetes/pki/ca.crt

* Generate the final certificate prod-user.crt by approving the certificate sign request, prod-user.csr, we made earlier. 
  
  `openssl x509 -req -in prod-user.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out prod-user.crt -days 1000 ; ls -ltr`
  
  ```
  root@kube-master:/home/prod-user/certs# openssl x509 -req -in prod-user.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out prod-user.crt -days 1000 ; ls -ltr
	Signature ok
	subject=CN = prod-user, O = devops
	Getting CA Private Key
	total 12
	-rw------- 1 root root 1679 Jan  8 01:44 prod-user.key
	-rw-r--r-- 1 root root  915 Jan  8 01:47 prod-user.csr
	-rw-r--r-- 1 root root 1017 Jan  8 01:52 prod-user.crt
  ```

### Setp4: Create kubeconfig file for the prod-user

* ***Add cluster details to configuration file:***
 
  `kubectl config --kubeconfig=prod-user.conf set-cluster production --server=https://192.168.198.147:6443 --certificate-authority=/etc/kubernetes/pki/ca.crt`

* ***Add user details to your configuration file:***
 
  `kubectl config --kubeconfig=prod-user.conf set-credentials prod-user --client-certificate=/home/prod-user/certs/prod-user.crt --client-key=/home/prod-user/certs/prod-user.key`

* ***Add context details to your configuration file:***
 
  `kubectl config --kubeconfig=prod-user.conf set-context prod --cluster=production --namespace=prod --user=prod-user`
  
* ***Set prod context for use:***

  `kubectl config --kubeconfig=prod-user.conf use-context prod`
  
* ***validate Aceess to API Server:***

  `kubectl --kubeconfig certs/prod-user.conf version --short`

  ``` 
  root@kube-master:/home/prod-user# kubectl --kubeconfig certs/prod-user.conf version --short
	Client Version: v1.17.0
	Server Version: v1.17.0
  ```

## Providing the Authorization to prod-user

### define a Role/ClusterRole -- what can be done 

```
	apiVersion: rbac.authorization.k8s.io/v1
	kind: Role
	metadata:
	namespace: prod
	name: prod-user-role
	rules:
	- apiGroups: ["*"] # "" indicates the core API group
	resources: ["pods","deployments", "replicasets"]
	verbs: ["get", "list", "watch", "create", "update"]
``` 

### define a rolebinding/clusterrolebinding ( bind role to a user, gives the user set of permmissions )

```
	apiVersion: rbac.authorization.k8s.io/v1
	# This role binding allows "testuser" to read pods in the "kube-system" namespace.
	kind: RoleBinding
	metadata:
	name: prod-user-rolebinding
	namespace: prod
	subjects:
	- kind: User
	  name: prod-user # Name is case sensitive
	 apiGroup: ""
	roleRef:
	kind: Role #this must be Role or ClusterRole
	name: prod-user-role # this must match the name of the Role or ClusterRole you wish to bind to
	apiGroup: rbac.authorization.k8s.io
```

## validate able to list deployments, pods replicasets 

```
root@kube-master:/home/prod-user# kubectl --kubeconfig prod-user.conf get deploy
NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
nginx                     1/1     1            1           3d19h
```
```
root@kube-master:/home/prod-user/# kubectl --kubeconfig prod-user.conf get rs
NAME                                 DESIRED   CURRENT   READY   AGE
nginx-778676476b                     1         1         1       3d19h

