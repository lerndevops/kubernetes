# Pod Priority and Pre-emption 

##  What is cluster Autoscaler ? 

> The kubernetes cluster autoscaler feature provides an excellent way to add more node to your cluster when your cluster is overloaded by heavy workload. Cluster autoscaler looks for the pods that cannot be scheduled and checks if adding a new node, similar to the other in the cluster, would help. If yes, then it resizes the cluster to accommodate the waiting pods. Cluster autoscaler also scales down the cluster if it notices that one or more nodes are not needed anymore for an extended period of time. There are implementation of Cluster autoscaler on GCP/GKE (best performance), AKS, EKS and Alibaba Cloud. 

> There are certain limitations in using Cluster Autoscaler - 

* Cluster Autoscaler doesnt work on physical clusters 
* Costs involved in adding more nodes
* Time taken in adding nodes to the cluster during which your pods are in PENDING state. 

##  Advantages of Pod priority and preemption 

> Pod priority and preemption is used as an alternative to Cluster Autoscaler (specially on physical clusters). It helps you to achieve high level of scheduling confidence for your **CRITICAL WORKLOADS** without overprovisioning your cluster.

> You can set priority to pods to determine its relative priority in comparison to other pods running in your system. If a pod with higher priority cannot be scheduled due to insufficient resources, kubernetes will preempt pods with lower priority to make space for your higher priority pod. 

##  Using Pod Priority

> In order to use Pod Priority (stable as per version 1.14) - Your kubernetes admin will create multiple **PodPriorityClasses** which determines levels of priorities. As a part of your pod deployment, each pod will have a corresponding **priorityClassName** which associates your pod with the corresponding **PodPriorityClass** 


##  Working with Pod Priority 

* Create a Priority Class

` kubectl create -f priorityclass.yaml`

```
kubectl get priorityclass
NAME                      VALUE        GLOBAL-DEFAULT   AGE
high-priority             1000000      false            48s
```

* Create a dummy deployment for nginx and scale it to overutilize your cluster

` kubectl run nginx --image=nginx` 

` kubectl scale deploy nginx --replicas=300`

> The above command overutilizes our cluster and you will see a lot of pods in pending state. 

* Create a pod with high priority 

> Verify the current number of pods running in the overloaded deployment

```
kubectl get deploy
NAME    READY     UP-TO-DATE   AVAILABLE   AGE
nginx   **214/300**   300          214         9m33s
```

> Create the pod with high priority

` kubectl create -f high-priority-nginx.yaml `

```
kubectl get pods | grep -i high
high-priority-nginx     1/1     Running   0          117s
```

> Check if an existing pod is evicted

```
kubectl get deploy
NAME    READY     UP-TO-DATE   AVAILABLE   AGE
nginx   **213/300**   300          213         11m
```











