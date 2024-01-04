# Setting up RBAC for Normal User 

### Setp1: create a user user1

```
mkdir -p $HOME/certs
cd $HOME/certs
```

### Setp2: Create The User Credentials

> Kubernetes does not have API Objects for User Accounts. Of the available ways to manage authentication. we will use OpenSSL certificates for their simplicity. 

#### The necessary steps are:

* Create a private key for your user. In this example, we will name the file user1.key:

   `openssl genrsa -out user1.key 2048`
   
   ```
   root@kube-master:/home/certs# openssl genrsa -out user1.key 2048
   Generating RSA private key, 2048 bit long modulus (2 primes)
   ........................+++++
   .................+++++
   e is 65537 (0x010001)
   ```

* Create a certificate sign request `user1.csr` using the private key we just created (user1.key in this example). Make sure you specify your username and group in the -subj section (CN is for the username and O for the group).

   `openssl req -new -key user1.key -out user1.csr -subj "/CN=user1/O=devops"`
   
* Locate Kubernetes cluster certificate authority (CA). This will be responsible for approving the request and generating the necessary certificate to access the cluster API. Its location is normally /etc/kubernetes/pki/ca.crt

* Generate the final certificate user1.crt by approving the certificate sign request, user1.csr, we made earlier. 
  
  `openssl x509 -req -in user1.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out user1.crt -days 1000 ; ls -ltr`
  
  ```
  root@kube-master:/home/certs# openssl x509 -req -in user1.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out user1.crt -days 1000 ; ls -ltr
	Signature ok
	subject=CN = user1, O = devops
	Getting CA Private Key
	total 12
	-rw------- 1 root root 1679 Jan  8 01:44 user1.key
	-rw-r--r-- 1 root root  915 Jan  8 01:47 user1.csr
	-rw-r--r-- 1 root root 1017 Jan  8 01:52 user1.crt
  ```

### Setp3: Create kubeconfig file for the user1

* ***Add cluster details to configuration file:***
 
  `kubectl config --kubeconfig=user1.conf set-cluster production --server=https://192.168.198.147:6443 --certificate-authority=/etc/kubernetes/pki/ca.crt`

* ***Add user details to your configuration file:***
 
  `kubectl config --kubeconfig=user1.conf set-credentials user1 --client-certificate=/home/user1/certs/user1.crt --client-key=/home/user1/certs/user1.key`

* ***Add context details to your configuration file:***
 
  `kubectl config --kubeconfig=user1.conf set-context prod --cluster=production --namespace=prod --user=user1`
  
* ***Set prod context for use:***

  `kubectl config --kubeconfig=user1.conf use-context prod`
  
* ***validate Aceess to API Server:***

  `kubectl --kubeconfig certs/user1.conf version --short`

  ``` 
  root@kube-master:/home/user1# kubectl --kubeconfig certs/user1.conf version --short
	Client Version: v1.17.0
	Server Version: v1.17.0
  ```

## Providing the Authorization to user1

### define a Role/ClusterRole -- what can be done 

```
	apiVersion: rbac.authorization.k8s.io/v1
	kind: Role
	metadata:
	namespace: prod
	name:  user1-role
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
	name: user1-rolebinding
	namespace: prod
	subjects:
	- kind: User
	  name: user1 # Name is case sensitive
	 apiGroup: ""
	roleRef:
	kind: Role #this must be Role or ClusterRole
	name: user1-role # this must match the name of the Role or ClusterRole you wish to bind to
	apiGroup: rbac.authorization.k8s.io
```

## validate able to list deployments, pods replicasets 

```
root@kube-master:/home/certs# kubectl --kubeconfig user1.conf get deploy
NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
nginx                     1/1     1            1           3d19h
```
```
root@kube-master:/home/user1/# kubectl --kubeconfig user1.conf get rs
NAME                                 DESIRED   CURRENT   READY   AGE
nginx-778676476b                     1         1         1       3d19h

