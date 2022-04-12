## Volumes 

> On-disk files in a container are ephemeral, which presents some problems for non-trivial applications when running in containers. 

> One problem is the loss of files when a container crashes. The kubelet restarts the container but with a clean state. 

> A second problem occurs when sharing files between containers running together in a Pod. 

### The Kubernetes `volume` abstraction solves both of these problems

### [MORE INFO](https://kubernetes.io/docs/concepts/storage/volumes/)
