## Kubernetes Services 

> Helps to Access application running inside a single / group of pods 

> a service is responsible for exposing an interface to a sinlge / group of pods, which enables network access from either within the cluster or between external processes and the service.

> Kubernetes services connect a set of pods to an abstracted service name and IP address. 

> Services provide discovery and routing between pods. For example, services connect an application front-end to its backend, each of which running in separate deployments in a cluster. 

> Services use labels and selectors to match pods with other applications.

### types of Kubernetes services

1. **`ClusterIP`** -- Exposes a service which is only accessible from within the cluster.
2. **`NodePort`** -- Exposes a service via a static port on each node’s IP.
3. **`LoadBalancer`** -- Exposes the service via the cloud provider’s load balancer.
4. **`ExternalName`** -- Maps a service to a predefined externalName field by returning a value for the CNAME record.

#### The core attributes of a Kubernetes service are:

1. A `label selector` that locates pods
2. The `type` of service to create
3. `Port` definitions
4. Optional mapping of incoming ports(nodeport) to a `targetPort`
