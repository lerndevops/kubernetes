# Kubernetes 1.18 & above Versions Only

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

