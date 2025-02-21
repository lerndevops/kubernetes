## "Sealed Secrets" for Kubernetes

> Problem: "I can manage all my K8s config in git, except Secrets."

> Solution: 
* Encrypt your Secret into a SealedSecret, which is safe to store - even inside a public repository. 
* The SealedSecret can be decrypted only by the controller running in the target cluster and nobody else (not even the original author) is able to obtain the original Secret from the SealedSecret.

## How do Sealed Secrets work?

### kubeseal client utility

1. _The user needs to encrypt Kubernetes secrets using kubeseal client utility._
2. _kubeseal client is responsible to talk to a sealed secret controller & use its public key to encrypt the secret._
3. _users now can store Sealed Secrets safely in Git Repository._
4. _Then the user or GitOps tools(ArgoCD/Flux) deploys the Sealed Secrets to the Kubernetes cluster._

### Sealed Secret Controller

1. _The Sealed Secretes Controller is a process/pod that runs inside the kubernetes cluster_

2.  _The Sealed Secrets controller inside the kubernetes cluster is responsible for watching for Sealed Secret custom resources. When it detects one, it decrypts the enclosed secret using its private key and then creates a standard Kubernetes Secret._ 

3. _Its significance lies in its ability to manage and decrypt Sealed Secrets securely, ensuring that only the cluster with the corresponding private key can access the original secret content._

![sealed-secret](https://github.com/lerndevops/kubernetes/blob/master/static/sealed-secret.png)

---
### [how to manage kubernetes secrets more ways](https://akuity.io/blog/how-to-manage-kubernetes-secrets-gitops)
---
### [click here to Install kubeseal client & controller](https://github.com/bitnami-labs/sealed-secrets/releases)
---