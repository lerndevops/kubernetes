## Setup Single Node Kubernetes Cluster with kubeadm

## Create VM with below specs
1) Ubuntu Linux OS
2) 2 cpu
3) 4gb ram
4) 15gb Hard disk

### Login to VM & follow below steps 

### Download Script 

> **`wget https://github.com/lerndevops/labs/raw/master/scripts/setupk8s-single-node-cluster.sh -P /tmp`**

### Execute the script 

> **`bash /tmp/setupk8s-single-node-cluster.sh`**

### Note

> **the Script takes care of**

1) Install Latest Version of Docker, cri-dockerd, kubeadm, kubelet, kubectl
2) initilize the kubernetes cluster with kubeadm
3) install calico cni network
4) configures kubectl client to communicate with cluster 
5) untaint master node to run workloads

## Validate the cluster  

> `kubectl get nodes -o wide` # check if the node is ready

> `kubectl get pods -o wide` # check if all the pods are running 
