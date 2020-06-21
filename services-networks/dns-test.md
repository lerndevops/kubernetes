# dns service/pod test

## Step1: create pod nginx & service nginx in a namespace called "testns"

```
# create

kubectl create namespace testns  ## creates testns namespace 
kubectl -n testns run nginx --image=nginx --expose --port=80 ## create a pod & service called nginx in testns namespace
```
```
#validate 

root@master:~# kubectl get all -n testns -o wide
NAME        READY   STATUS    RESTARTS   AGE   IP            NODE    NOMINATED NODE   READINESS GATES
pod/nginx   1/1     Running   0          66s   10.244.1.54   node1   <none>           <none>

NAME            TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE   SELECTOR
service/nginx   ClusterIP   10.102.75.3   <none>        80/TCP    66s   run=nginx
```

## Step2: create pod mynginx & service mynginx in a namespace called "default"

```
# create


kubectl -n default run mynginx --image=nginx --expose --port=80 ## create a pod & service called nginx in testns namespace
```
```
# validate

root@master:~# kubectl get all -n default -o wide
NAME        READY   STATUS    RESTARTS   AGE   IP            NODE    NOMINATED NODE   READINESS GATES
pod/mynginx   1/1     Running   2          18h   10.244.1.49   node1   <none>           <none>

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE     SELECTOR
service/mynginx      ClusterIP   10.102.183.125   <none>        80/TCP   10m     env=test
```


## Step3: create another pod in any namespace which has netutils so that we can run a nslookup command

```
# Create

kubectl -n testns run dnstest --image=lerndevops/netshoot --rm -it -- /bin/bash

the above command will create new pod called dnstest in testns namespace & get you insideit, from inside pod we can try accessing pods using their service dns & pod dns 
```

## Step4: test Service DNS 

```
Note: in step3 we are getting inside pod, ensure we are inside pod to run below commands

# check default dns values configured for the pod
 
	bash-5.0# cat /etc/resolv.conf
	nameserver 10.96.0.10
	search testns.svc.cluster.local svc.cluster.local cluster.local us-central1-a.c.devops-262910.internal c.devops-262910.internal google.internal
	options ndots:5

# Note:
	to form the service DNS get the service name then add .namespace.svc
	example: servicename.namespace.svc
			  nginx.testns.svc

# nslookup the service nginx using its DNS in testns namespace
 
	bash-5.0# nslookup nginx.testns.svc
	Server:         10.96.0.10
	Address:        10.96.0.10#53

	Name:   nginx.testns.svc.cluster.local
	Address: 10.102.75.3

# nslookup the service mynginx using its DNS in default namespace

	bash-5.0# nslookup mynginx.default.svc
	Server:         10.96.0.10
	Address:        10.96.0.10#53

	Name:   nginx-svc.default.svc.cluster.local
	Address: 10.102.183.125
```

## Step5: test POD DNS

```
# Note:
	to form the pod DNS get the podip & replace "." with "-" then add .namespace.pod
	example: covnert 1.2.3.4 to 1-2-3-4 & add .namespace.pod
			  1-2-3-5.testns.pod
		  
# nslookup the pod nginx using its DNS in testns namespace

	bash-5.0# nslookup 10-244-1-54.testns.pod
	Server:         10.96.0.10
	Address:        10.96.0.10#53

	Name:   10-244-1-54.testns.pod.cluster.local
	Address: 10.244.1.54

# nslookup the pod mynginx using its DNS in default namespace

	bash-5.0# nslookup 10-244-1-49.default.pod
	Server:         10.96.0.10
	Address:        10.96.0.10#53

	Name:   10-244-1-49.default.pod.cluster.local
	Address: 10.244.1.49
```
