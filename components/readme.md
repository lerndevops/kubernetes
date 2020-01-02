## bootstrap kubernetes cluster 
### kubeadm
> Kubeadm is a tool built to provide kubeadm init and kubeadm join as best-practice “fast paths” for creating Kubernetes clusters.

> kubeadm performs the actions necessary to get a minimum viable cluster up and running. 

> By design, it cares only about bootstrapping, not about provisioning machines. 

> Likewise, installing various nice-to-have addons, like the Kubernetes Dashboard, monitoring solutions, and cloud-specific addons, is not in scope.

| command | description |
|-------- | ----------- |
| ***kubeadm init*** | to bootstrap a Kubernetes control-plane node |
| ***kubeadm join*** | to bootstrap a Kubernetes worker node and join it to the cluster |
| ***kubeadm upgrade*** | to upgrade a Kubernetes cluster to a newer version |
| ***kubeadm config*** | if you initialized your cluster using kubeadm v1.7.x or lower, to configure your cluster for kubeadm upgrade |
| ***kubeadm token*** | to manage tokens for kubeadm join |
| ***kubeadm reset*** | to revert any changes made to this host by kubeadm init or kubeadm join |
| ***kubeadm version*** | to print the kubeadm version |
| ***kubeadm alpha*** | to preview a set of features made available for gathering feedback from the community |



## Kube Master Components

| Component | Description |
| --------- | ----------- |
| ***Etcd*** | This is a data store used by Kubernetes to store all information about the cluster. It’s critical for keeping everything up to date |
| ***kube-apiserver*** | This component exposes Kubernetes API to users allowing them to create API resources, run applications, and configure various parameters of the cluster.|
| ***kube-controller-manager*** | The component that manages API objects created by users. It makes sure that the actual state of the cluster always matches the desired state |
| ***kube-scheduler*** | This component is responsible for scheduling user workloads on the right infrastructure. When scheduling applications, kube-scheduler considers various factors such as available node resources, node health, and availability, as well as user-defined constraints.|
| ***cloud-controller-manager*** | This component embraces various controllers, all of which interact with the cloud providers’ APIs.|


## Kube Node Components

| Component | Description |
| --------- | ----------- |
| ***kube-proxy*** | kube-proxy is a network proxy that runs on each node in your cluster. kube-proxy maintains network rules on nodes. These network rules allow network communication to your Pods from network sessions inside or outside of your cluster. |
| ***kubelet*** | The kubelet is the primary “node agent” that runs on each node & manages the containers/pods running on each node |
| ***Container Runtime*** | A container runtime is software that executes containers and manages container images on a node. Today, the most widely known container runtime is Docker, but there are other container runtimes in the ecosystem, such as rkt, containerd, and lxd |



## Kube CLI
### kubectl
> Kubernetes objects can be created, updated, and deleted by using the kubectl command-line tool along with an object configuration file written in YAML or JSON.
