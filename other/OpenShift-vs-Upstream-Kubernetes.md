# Openshift vs Upstream kubernetes

## Openshift Platoforms
OpenShift is Red Hat’s enterprise Kubernetes distribution, available as both a commercial software solution (OpenShift Container Platform, available to run on OpenStack, VMware, AWS, GCP, Azure and any platform that delivers RHEL 7) and a public cloud service (OpenShift Dedicated and OpenShift Online). 

## Openshift Security features implications

In addition to the additional API entities, as mentioned by @SteveS, Openshift also has advanced security concepts.

This can be very helpful when running in an Enterprise context with specific requirements regarding security. As much as this can be a strength for real-world applications in production, it can be a source of much frustration in the beginning. One notable example is the fact that, by default, containers run as root in Kubernetes, but run under an arbitrary user with a high ID (e.g. 1000090000) in Openshift. This means that many containers from DockerHub do not work as expected. For some popular applications, The Red Hat Container Catalog supplies images with this feature/limitation in mind. However, this catalog contains only a subset of popular containers.



## Features chart

FEATURE	KUBERNETES	OPENSHIFT ORIGIN	OPENSHIFT CONTAINER PLATFORM
Multi-host container scheduling 
	
Self-service provisioning  

Service-discovery 
Persistent storage		

Multi-tenancy			

Collaboration			

Networking			

Image registry			

Monitoring			

Log aggregation			

CI/CD and DevOps			

Application services (databases, runtimes, …)			

Middleware services			

Built-in operational management			

Enterprise-grade operating system			

100% Open Source			

Community support			

Enterprise 24/7 Support			

Security response team			

Stable Lifecycle (7 years)			

## Going with upstream kubernetes

I evaluated both and really liked some of the built in features of OpenShift but went with Kubernetes for the following reasons.
### Good
- More flexible (can benefit of all plugins/drivers for kubernetes, while on OpenShift is is fixed)
- Can stay up to date with the rapid development of up stream Kubernetes
- Broader community of users and more example applications
- Can be used more like a framework than a PaaS (more flexible)

### Bad
- Some of the downsides of going with upstream Kubernetes are
- Need to layer your own PaaS solution if that's what you want (Dies, redspread etc.)
- Need to manage your own releases and upgrades
- Paid support comes from third party (CoreOS, etc.)

There are lots (maybe too many) ways to get started with up stream Kuberenetse. I think the main difference is with Kubernetes you'll start from a basic system with some methodologies for deploying/managing applications. With OpenShift you have a complete opinionated solution that is only guaranteed to work under certain constrains. If your requirements match the use case of OpenShift then it's a great solution.


## Where Openshift really shines
- security
- glusterfs/ceph integration
- dev utils like source code to image allows you to push source code to the cluster
- docs and support
