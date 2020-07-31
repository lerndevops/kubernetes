Containers within a pod can interact with each other in various ways:

• Network: Containers can access any listening ports on containers within the same pod, even if those ports are not exposed outside the pod.

• Shared Storage Volumes: Containers in the same pod can be given the same mounted storage volumes, which allows them to interact with the same files.

• SharedProcessNamespace:ProcessnamespacesharingcanbeenabledbysettingshareProcessNamespace true in the pod spec. This allows containers within the pod to interact with, and signal, one an-other’s processes.



Ambassador: An haproxy ambassador container receives network traffic and forwards it to the main container. 
Example: An ambassador container listens on a custom port, and forwards the traffic to the main container’s hard-coded port.

Sidecar: A sidecar container enhances the main container in some way, adding functionality to it. 
Example: a sidecar periodically syncs files in a webserver container’s file system from a Git repository.

Adapter: An adapter container transforms the output of the main container. 
Example: An adapter container reads log output from the main container and transforms it.
