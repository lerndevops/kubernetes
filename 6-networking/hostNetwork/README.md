# hostPort

> The **`hostPort`** setting applies to the Kubernetes containers. 

> The container port will be exposed to the external network at **`<hostIP>:<hostPort>,`** where the `hostIP` is the IP address of the `Kubernetes node` where the container is running and the `hostPort` is the port requested by the user.

### drawbacks of hostPort

1. **The hostPort feature allows to expose a single container port on the host IP.**

2. **Every time the pod is restarted Kubernetes can reschedule the pod onto a different node and so the application will change its IP address.**

3. **Two applications requiring the same port cannot run on the same node. This can lead to port conflicts when the number of applications running on the cluster grows.**

4. **the `hostPort` is not a good way to make your applications accessible from outside of the cluster.** 
