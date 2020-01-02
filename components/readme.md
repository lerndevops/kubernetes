## bootstrap kubernetes cluster 
### kubeadm
> Kubeadm is a tool built to provide kubeadm init and kubeadm join as best-practice “fast paths” for creating Kubernetes clusters.

> kubeadm performs the actions necessary to get a minimum viable cluster up and running. 

> By design, it cares only about bootstrapping, not about provisioning machines. 

> Likewise, installing various nice-to-have addons, like the Kubernetes Dashboard, monitoring solutions, and cloud-specific addons, is not in scope.

* ***kubeadm init*** to bootstrap a Kubernetes control-plane node
* ***kubeadm join*** to bootstrap a Kubernetes worker node and join it to the cluster
* ***kubeadm upgrade*** to upgrade a Kubernetes cluster to a newer version
* ***kubeadm config*** if you initialized your cluster using kubeadm v1.7.x or lower, to configure your cluster for kubeadm upgrade
* ***kubeadm token*** to manage tokens for kubeadm join
* ***kubeadm reset*** to revert any changes made to this host by kubeadm init or kubeadm join
* ***kubeadm version*** to print the kubeadm version
* ***kubeadm alpha*** to preview a set of features made available for gathering feedback from the community

## Kube Master Components

### API Server

> is the server which take request from a client (kubectl) always & responds back. it is the point of contact in the k8s cluster to perform any operation.

> The Kubernetes API server validates and configures data for the api objects which include pods, services, replicationcontrollers etc...

### etcd
> etcd is a distributed key-value store. etcd is the primary datastore of Kubernetes; storing and replicating all Kubernetes cluster state. 
> As a critical component of a Kubernetes cluster having a reliable automated approach to its configuration and management is imperative 

### Controller manager
> a controller manager is a control loop that watches the shared state of the cluster through the apiserver and makes changes attempting to move the current state towards the desired state.

### schedular
> scheduler is in charge of scheduling pods onto nodes.

## Kube Node Components

### kube-proxy
> kube-proxy is a network proxy that runs on each node in your cluster. kube-proxy maintains network rules on nodes. These network rules allow network communication to your Pods from network sessions inside or outside of your cluster. 

### kubelet
> The kubelet is the primary “node agent” that runs on each node & manages the containers/pods running on each node

### Container Runtime
> A container runtime is software that executes containers and manages container images on a node. Today, the most widely known 
> container runtime is Docker, but there are other container runtimes in the ecosystem, such as rkt, containerd, and lxd


## Kube CLI
### kubectl
> Kubernetes objects can be created, updated, and deleted by using the kubectl command-line tool along with an object configuration file written in YAML or JSON.
