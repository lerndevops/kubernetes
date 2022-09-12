## fluxCD

> Flux is a set of continuous and progressive delivery solutions for Kubernetes that are open and extensible

## Core Concepts

### Bootstrap

> The process of installing the Flux components in a GitOps manner is called a bootstrap.

> The manifests are applied to the cluster, a GitRepository and Kustomization are created for the Flux components, then the manifests are pushed to an existing Git repository (or a new one is created).

> **Flux can manage itself just as it manages other resources. The bootstrap is done using the flux CLI**

### Sources

> A Source defines the origin of a repository containing the desired state of the system and the requirements to obtain it 

> Sources produce an artifact that is consumed by other Flux components to perform actions, like applying the contents of the artifact on the cluster. A source may be shared by multiple consumers to deduplicate configuration and/or storage.

> **The origin of the source is checked for changes on a defined interval, if there is a newer version available that matches the criteria, a new artifact is produced.**

> All sources are specified as Custom Resources in a Kubernetes cluster, examples of sources are `GitRepository`, `OCIRepository`, `HelmRepository` and `Bucket` resources 

> for more information, look at [the source controller documentation](https://fluxcd.io/flux/components/source/)

### Reconciliation

> **Reconciliation refers to ensuring that a given state (e.g. application running in the cluster, infrastructure) matches a desired state declaratively defined somewhere (e.g. a Git repository).**

> There are various examples of these in Flux:

* `HelmRelease reconciliation:` ensures the state of the Helm release matches what is defined in the resource, performs a release if this is not the case (including revision changes of a HelmChart resource).

* `Kustomization reconciliation:` ensures the state of the application deployed on a cluster matches the resources defined in a Git or OCI repository or S3 bucket.

### Kustomization

> The `Kustomization` custom resource represents a local set of Kubernetes resources (e.g. kustomize overlay) that Flux is supposed to reconcile in the cluster.

> The reconciliation runs every five minutes by default, but this can be changed with .spec.interval

> If you make any changes to the cluster using kubectl edit/patch/delete, they will be promptly reverted. You either suspend the reconciliation or push your changes to a Git repository.