# Troubleshooting Common Kubernetes Issues

###  Kubernetes is a complex system, and plenty of things can go wrong when using it

### here you can find common Kubernetes troubleshooting scenarios that IT and DevOps teams may encounter, and how to address them.

## Common Networing Issues
* Kubernetes supports a variety of networking plugins and each one can fail in its own way
* At its core, Kubernetes relies on the [Netfilter](https://www.netfilter.org/) kernel module to set up low level cluster IP load balancing. This requires two critical modules, IP forwarding and bridging, to be on.
[**`Issue 1`** -- Kernel IP forwarding]
[**`Issue 2`** -- Bridge Netfilter]
[**`Issue 3`** -- Firewall rules block overlay network traffic]
[**`Issue 4`** -- AWS source/destination check is turned on]
[**`Issue 5`** -- Pod CIDR conflicts]

