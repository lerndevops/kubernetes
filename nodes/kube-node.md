## what is kubernetes node
```
A node is a worker machine in Kubernetes, previously known as a minion. 
A node may be a VM or physical machine, depending on the cluster. 
Each node contains the services necessary to run pods and is managed by the master components.
```
> Unlike pods and services, a node is not inherently created by Kubernetes
> it is created externally by cloud providers like Google Compute Engine, or it 
> exists in your pool of physical or virtual machines. So when Kubernetes creates 
> a node, it creates an object that represents the node. After creation, 
> Kubernetes checks whether the node is valid or not.

```
A node’s status contains the following information:
	Addresses
	Conditions
	Capacity and Allocatable
	Info
```

### Addresses
```
The usage of these fields varies depending on your cloud provider or bare metal configuration.
	HostName: The hostname as reported by the node’s kernel. Can be overridden via the kubelet --hostname-override parameter.
	ExternalIP: Typically the IP address of the node that is externally routable (available from outside the cluster).
	InternalIP: Typically the IP address of the node that is routable only within the cluster.
```
### Conditions
```
The conditions field describes the status of all Running nodes. Examples of conditions include

	OutOfDisk	        # True if there is insufficient free space on the node for adding new pods, otherwise False
	MemoryPressure	    # True if pressure exists on the node memory – that is, if the node memory is low; otherwise False
	DiskPressure	    # True if pressure exists on the disk size – that is, if the disk capacity is low; otherwise False
	NetworkUnavailable	# True if the network for the node is not correctly configured, otherwise False
	Ready	            # True if the node is healthy and ready to accept pods, False if the node is not healthy and is not accepting pods, and Unknown if the node controller has not heard from the node in the last node-monitor-grace-period (default is 40 seconds)
	PIDPressure	        # True if pressure exists on the processes – that is, if there are too many processes on the node; otherwise False
```
### Capacity and Allocatable
```
Describes the resources available on the node: CPU, memory and the maximum number of pods that can be scheduled onto the node.

The fields in the capacity block indicate the total amount of resources that a Node has. The allocatable block indicates the amount of resources on a Node that is available to be consumed by normal Pods.
```
### Info
```
Describes general information about the node, such as kernel version, Kubernetes version (kubelet and kube-proxy version), Docker version (if used), and OS name. This information is gathered by Kubelet from the node
```


### [MoreInfo] (https://kubernetes.io/docs/concepts/architecture/nodes/)
