# What is Kubernetes Security?
> Kubernetes Security is based on the 4C’s of cloud native security: Cloud, Cluster, Container, and Code
* **`Cloud (or Corporate Datacenter/Colocation facility):`** The underlying physical infrastructure is the basis of Kubernetes security. Whether the cluster is built on one’s own datacenter or a cloud provider, basic cloud provider (or physical security) best practices must be observed.
* **`Cluster:`** Securing a Kubernetes cluster involves both the configurable components such as the Kubernetes API and security of all the applications that are part of the cluster. Since most cloud-native applications are designed around microservices and APIs, applications are only as secure as the weakest link in the chain of services that comprise the entire application.
* **`Container:`** Container design best practices consist of: starting with the smallest code base possible (excluding unnecessary libraries or functions), avoiding granting unnecessary privileges to users in the container, and ensuring that containers are scanned for vulnerabilities at build time.
* **`Code:`** Code presents a major attack surface for any Kubernetes environment. Simple policies such as encrypting TCP using TLS handshakes, not exposing unused ports, scanning, and testing regularly can help prevent security issues from arising in a production environment.

## Why is Kubernetes Security important through the container lifecycle?
* Kubernetes security is important throughout the container lifecycle due to the distributed, dynamic nature of a Kubernetes cluster. Different security approaches are required for each of the three phases of an application lifecycle: build, deploy, and runtime. Kubernetes provides innate security advantages. For example, application containers are typically not patched or updated — instead, container images are replaced entirely with new versions. This enables strict version control and permits rapid rollbacks if a vulnerability is uncovered in new code.

* However, since individual pods are transient and ephemeral, the ever-changing runtime environment can present challenges for IT security professionals, as applications and API links to other applications and services are constantly in flux.

## What are the top Kubernetes Security vulnerabilities through the application’s lifecycle ?
> Kubernetes security tools should:

* Reduce time to ensure code is free of compromises.
* Provide digital signatures for a level of trust for code.
* Provide visibility and transparency not only in code but in configuration issues.
* Prevent ingress (incoming connection) or egress (outbound connection) of information to unsecure services.

## What are the top Kubernetes security vulnerabilities during build?
* Code from untrusted registries.Untrusted code can include malware or backdoors that could unintentionally grant access to bad actors.
* Bloated base images. Less is more for containerized applications, so developers should eliminate unnecessary packages, libraries, and shells that could be compromised. 

## What are the top Kubernetes security vulnerabilities during deployment?
* Granting unnecessary privileges. Wherever possible, keep privileges to a minimum and mount only the secrets that a task requires to shrink the attack surface.
* Failure to isolate applications in the cluster. Namespaces should be used to keep resources and teams separate from each other. 
* Lateral motion within the cluster. Use policies that segment the network to prevent lateral movement of an attack within the cluster.
* Unauthorized access. Ensure role-based access controls (RBAC) are properly configured to limit access.

## What are the top Kubernetes security vulnerabilities during runtime?
* Infrastructure attacks. During runtime, Kubernetes infrastructure elements including the API server, etcd, and controllers all present their own attack surfaces.
* Complexity. The ongoing health of a Kubernetes cluster has many moving parts. Compromised containers must be quickly isolated, stopped, and replaced with healthy ones while the source of the attack is located and remediated. 

### [What is a high-level Kubernetes security checklist? Best Practices](https://github.com/lerndevops/educka/blob/master/security/Security-Best-Practices.md)
