## About the NEW CKA Exam (From September 2020)

> **The new CKA Certification Exam is aligned with CKAD exam pattern in terms of duration, the number of questions and passing score.**

> **Time management is more critical compare with the old version of CKA exam.**

> **Questions are weightage in three categories like 4%, 7% & 8%. Most of the 4% weightage questions are easy to answer except 1 or 2. However, if you stuck with any 4% weighted marks question then flag it & move on without investing too much time.**

> **Troubleshooting raised from 10% to 30% and logging/monitoring also included in it. There is a much greater emphasis on troubleshooting and hence, the question related to troubleshooting carries more weight marks like 7-8%.**

> **1/4 of the new curriculum is dedicated to the cluster Architecture, installation & configuration including Kubeadm to install/ version upgrade on a kubernetes cluster, etcd backup and restore, Manage RBAC. Obviously, cluster related configuration questions will carry the highest weightage %.**

> **Service & Networking increases by 9% in the weight, but there are not many changes except how to use Ingress resources and network policy. Questions coming from this section is weighted to 4% and 7%.**

> **Workload & Scheduling capture all points of the previous Application Lifecycle Management including label selectors, scale the deployment, reschedule pods and so on. Most of the questions coming from this section are easy to answer and carry 4% weightage.**

> **Storage curriculum has no significant changes. In my opinion, this is the only section which is almost similar to previous CKA version.**

> **mostly the security is separated out of the CKA exam and LF is planning to include this in their CKS(Certified Kubernetes Security Specialist) certification exam which is scheduled to release in November 2020.**


<p align="center"> <img src="https://github.com/lerndevops/educka/blob/master/static/CKA-Old-vs-New.PNG"> </p>

## Kubernetes 1.18 & above Versions Only

## `Generate Pod Yamls`

```
kubectl run nginx --image=nginx --dry-run=client -o yaml  ## generate pod yaml file
kubectl run nginx --image=nginx --restart=Never --dry-run=client -o yaml  ## generate pod yaml file with restartPolicy: Never
kubectl run nginx --image=nginx -l="app=web,env=dev" --dry-run=client -o yaml  ## generate pod yaml file with labels provided
kubectl run nginx --image=nginx --env="hello=world" --env="me=naresh" --dry-run=client -o yaml ## generate pod yaml with env variables
kubectl run nginx --image=nginx --restart=OnFailure --env='hello=world' -l='app=web' --limits='cpu=100m,memory=150Mi' --dry-run=client -o yaml ## generate pod yaml with various parametes
kubectl run nginx --image=nginx --port=80 --expose --dry-run=client -o yaml ## generate pod yaml file & Service yaml file together
```

## `Create Pod` 

```
## Note: remove --dry-run -o yaml from all above commands to create pods ex as below. 
kubectl run nginx --image=nginx  # create a pod 
```

## `Generate Deployment Yamls`

```
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml  ## generate Deployment yaml file
```

## `Create Deployment` 

```
## Note: remove --dry-run -o yaml from all above commands to create Deployment ex as below. 

kubectl create deployment nginx --image=nginx  ## creates a Deployment 

```

## `scale up/down number of replicas`

```
kubectl scale deployment nginx --replicas=3  ## scale a deployment named nginx 
kubectl scale replicaset nginx --replicas=3  ## scale a replicaset named nginx
kubectl scale statefulset nginx --replicas=3  ## scale a statefulset named nginx
```

## `Generate Service yamls`

```
kubectl create service nodeport nginx --tcp=80:80 --dry-run=client -o yaml  ## generate a service yaml with type: NodePort name: 'nginx' & selector app: nginx
kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml  ## generate a service yaml with type: NodePort, name: 'nginx' & selector app: nginx with nodeport given
kubectl create service clusterip nginx --tcp=80:80 --dry-run=client -o yaml ## generate a service yaml with type: ClusterIP
```

## `Generate Service yaml for to expose/access running pods/deployment`

```
## Note: to use below commands, the pod/deployment must be created first

kubectl expose pod mypod --port=80 --target-port=8080 --type=NodePort --dry-run=client -o yaml
kubectl expose deployment mydep --port=80 --target-port=8080 --type=NodePort --dry-run=client -o yaml 
kubectl expose -f pod.yaml  --port=80 --target-port=8080 --type=NodePort --dry-run=client -o yaml

kubectl expose pod mypod --port=80 --target-port=8080 --type=ClusterIP --dry-run=client -o yaml
kubectl expose deployment mydep --port=80 --target-port=8080 --type=ClusterIP --dry-run=client -o yaml 
kubectl expose -f pod.yaml  --port=80 --target-port=8080 --type=ClusterIP --dry-run=client -o yaml
```

