## Kubernetes Object / Resources 

#### Anything we create in kubernetes is called as Object
```
		ex: pod,replicaset,deployment,service etc..
```
#### Kubernetes API Server provides various APIs ( also called API Versions ) and resource types which we can create in kubernetes cluster

#### The API server implements a RESTful API over HTTP, performs all API operations, and is responsible for storing API objects into a persistent storage backend

#### API request must include that information as JSON in the request body. Most often, we provide the information to kubectl in a .yaml file. kubectl converts the information to JSON when making the API request.

#### Required Fields in a manifest file (".yaml")
```
In the .yaml file for the Kubernetes object you want to create, you’ll need to set values for the following fields:

    apiVersion - Which version of the Kubernetes API you’re using to create this object
    kind - What kind of object you want to create
    metadata - Data that helps uniquely identify the object, including a name string, UID, and optional namespace
    spec - What state you desire for the object
```

#### Every resource is an endpoint in the Kubernetes API that stores a collection of API objects of a certain kind, we should use them appropriatly while creating any resource in kubernetes.

```
		kubectl api-versions   ## to list all APIs available 
		kubectl api-resources  ## to see what KIND of resources can be created in kubernetes
```

#### To create pod resource, we can use as below in manifest file.  
```
		ex: apiVersion: v1
		    Kind: Pod
		    metadata:
		    spec:
```
#### detailed information about an object / a resource 
```
	kubectl explain <resourcetype>
	Ex:
	    kubectl explain pod
	    kubectl explain deployment
	    etc...
```

# Lab

### creating reosurces in kubernetes declarative model

```
kubectl apply -f ./my-manifest.yaml            # create resource(s)
kubectl apply -f ./my1.yaml -f ./my2.yaml      # create from multiple files
kubectl apply -f ./dir                         # create resource(s) in all manifest files in dir
kubectl apply -f https://git.io/vPieo          # create resource(s) from url
```

### Run a POD command line
```
kubectl run -i --tty busybox --image=busybox -- sh  # Run pod as interactive shell
kubectl run nginx --image=nginx --restart=Never -n mynamespace   # Run pod nginx in a specific namespace
kubectl run nginx --image=nginx --restart=Never --dry-run -o yaml > pod.yaml     # Run pod nginx and write its spec into a file called pod.yaml
```

### get POD information 
```
kubectl get pods                         # list all running pods in current active namespace
kubectl get pods -n kube-system          # list all running pods in specified namespace
kubectl get pods --all-namespaces        # list all running pods in all namespaces available
kubectl get pods -o wide                 # list all running pods in current active namespace wider output
kubectl get pods --show-labels           # list pods with labels
kubectl get pods -l env=prod             # list pods with matching labels
kubectl get pods -n kube-system --watch  # watch the output
kubectl get pods --field-selector='status.phase=Running' # List running pods
kubectl get pods --field-selector=status.phase!=Running --all-namespaces  ## list unhealthy pods
kubectl get pods --selector="app=nginx"  # list pods which have selector key,value
kubectl get pods -o='custom-columns=PODS:.metadata.name,Images:.spec.containers[*].image' #  list pods and images
kubectl get pods -o='custom-columns=PODS:.metadata.name,CONTAINERS:.spec.containers[*].name' # List pods and containers
kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'   #List pods Sorted by Restart Count
kubectl get pod <podname> -o yaml      # detailed manifest file from apiserver yaml format
kubectl get pod <podname> -o json      # detailed manifest file from apiserver json format
```
### describe / inspect a POD
```
kubectl describe pod <podname>              # detailed output about a pod in current namespace
kubectl describe pod <podname> -n namespace # detailed output about a pod in current namespace

```
### add / remove Lables for a POD
```
kubectl label pods dummy-input env=prod   # add label to pods
kubectl label pods dummy-input env-        # remove a label
```
### Check logs of a POD
```
kubectl logs my-pod                                 # dump pod logs (stdout)
kubectl logs -l name=myLabel                        # dump pod logs, with label name=myLabel (stdout)
kubectl logs my-pod --previous                      # dump pod logs (stdout) for a previous instantiation of a container
kubectl logs my-pod -c my-container                 # dump pod container logs (stdout, multi-container case)
kubectl logs -l name=myLabel -c my-container        # dump pod logs, with label name=myLabel (stdout)
kubectl logs my-pod -c my-container --previous      # dump pod container logs (stdout, multi-container case) for a previous instantiation of a container
kubectl logs -f my-pod                              # stream pod logs (stdout)
kubectl logs -f my-pod -c my-container              # stream pod container logs (stdout, multi-container case)
kubectl logs -f -l name=myLabel --all-containers    # stream all pods logs with label name=myLabel (stdout)
```
### Get inside a POD
```
kubectl attach my-pod -i                             # Attach to Running Container in existing pod 
kubectl exec my-pod -- ls /                          # Run command in existing pod (1 container case)
kubectl exec -it my-pod -- /bin/bash                 # get interactive shell of the container in existing pod ( 1 container case )
kubectl exec my-pod -c my-container -- ls /          # Run command in existing pod (multi-container case)
kubectl exec -it my-pod -c my-container -- /bin/bash # get interative shell of the container in existing pod ( multi container ) 
```

### Expose POD to access outside of the cluster

```
kubectl port-forward my-pod 5000:6000                # Listen on port 5000 on the local machine and forward to port 6000 on my-pod
kubectl expose pod nginx --port=80 --target-port=80  # expose pod as service within the cluster
kubectl expose pod nginx --target-port=80 --type=NodePort # expose pod as service within the cluster & outside of the cluster
```

### Delete a POD
```
kubectl delete pods <podname>                    # delete a pod in current active namespace
kubectl delete pods <pod-name> -n <my-namespace> # delete a pod in specified namespace
kubectl delete pods -l env=test                  # delete pods matching labels
kubectl delete pods --all                        # delete all pods 
kubectl delete pod <pod-name> --grace-period=0 --force  # delete pod forcefully
```
