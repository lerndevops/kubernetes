# Security Contexts

> A security context is a set of constraints that are applied to a container in order to achieve the following goals:

* Ensure a clear isolation between container and the underlying host it runs on
* Limit the ability of the container to negatively impact the infrastructure or other containers

## Use Cases

> In order of increasing complexity, following are example use cases that would be addressed with security contexts:

1.  Kubernetes is used to run a single cloud application. In order to protect
nodes from containers:
    * All containers run as a single non-root user
    * Privileged containers are disabled
    * All containers run with a particular MCS label
    * Kernel capabilities like CHOWN and MKNOD are removed from containers

2.  Just like case #1, except that I have more than one application running on
the Kubernetes cluster.
    * Each application is run in its own namespace to avoid name collisions
    * For each application a different uid and MCS label is used

3.  Kubernetes is used as the base for a PAAS with multiple projects, each
project represented by a namespace.
    * Each namespace is associated with a range of uids/gids on the node that
are mapped to uids/gids on containers using linux user namespaces.
    * Certain pods in each namespace have special privileges to perform system
actions such as talking back to the server for deployment, run docker builds,
etc.
    * External NFS storage is assigned to each namespace and permissions set
using the range of uids/gids assigned to that namespace.
