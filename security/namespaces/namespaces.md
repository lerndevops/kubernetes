## what are namespaces ?
	* Kubernetes supports multiple virtual clusters backed by the same physical cluster. These virtual clusters are called namespaces.

	* Namespaces are a way to divide cluster resources between multiple users (via resource quota).

	* Namespaces provide a scope for names. Names of resources need to be unique within a namespace, but not across namespaces.

	* Namespaces can not be nested inside one another and each Kubernetes resource can only be in one namespace

	* Namespaces are intended for use in environments with many users spread across multiple teams, or projects.

## Kubernetes starts with three initial namespaces
	* default: The default namespace for objects with no other namespace
	
	* kube-system: The namespace for objects created by the Kubernetes system
	
	* kube-public: This namespace is created automatically and is readable by all users (including those not authenticated). This namespace is mostly reserved for cluster usage, in case that some resources should be visible and readable publicly throughout the whole cluster. The public aspect of this namespace is only a convention, not a requirement.

## Not All Objects/Resources are in a Namespace
	* Most Kubernetes resources (e.g. pods, services, replication controllers, and others) are in some namespaces. However namespace resources are not themselves in a namespace. 

	* And low-level resources, such as nodes and persistentVolumes, are not in any namespace.

	* To see which Kubernetes resources are and aren’t in a namespace:
		# In a namespace
			kubectl api-resources --namespaced=true
		# Not in a namespace
			kubectl api-resources --namespaced=false

	* Kubernetes namespaces help different projects, teams, or customers to share a Kubernetes cluster.
		It does this by providing the following:
			* A scope for Names.
			* A mechanism to attach authorization and policy to a subsection of the cluster.

## Managing your active Namespace
	* Out of the box, your active namespace is the “default” namespace. Unless you specify a Namespace in the YAML, all Kubernetes commands will use the active Namespace.

	* Unfortunately, trying to manage your active Namespace with kubectl can be a pain
	
### More Info -- [namespaces](https://kubernetes.io/docs/tasks/administer-cluster/namespaces/)
