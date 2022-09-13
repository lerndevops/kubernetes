## Declarative Management of Kubernetes Objects Using Kustomize 

> **Kubernetes native configuration management**

* Kustomize helps customizing config files in a template free way.
* Kustomize lets you customize raw, template-free YAML files for multiple purposes, leaving the original YAML untouched and usable as is.
* Kustomize provides a number of handy methods like generators to make customization easier.
* Kustomize uses patches to introduce environment specific changes on an already existing standard config file without disturbing it.

> **Kustomize is a standalone tool to customize Kubernetes objects through a kustomization file.**

> **`Since 1.14, Kubectl also supports the management of Kubernetes objects using a kustomization file.`** 

## Understanding Kustomize

### Bases and overlays

> Kustomize's configuration transformation approach leverages the use of kustomization layers so that the same base configuration files can be reused across multiple kustomization configurations. It achieves this with the concepts of bases and overlays.

* `A base is a directory containing a file called kustomization.yaml, which can enumerate some set of resources with some customizations that will be applied to them. A base should be declared in the resources field of a kustomization file.`

* `An overlay is a directory that refers to another kustomization directory as its, or one of its, bases.`

> A base can be thought of as a preliminary step in a pipeline, having no knowledge of the overlays that it is referenced by. After a base is finished processing, it sends its resources as input to the overlay to transform according to the overlay's specification.

## apply kustomize directories from github repo 

```
## kustomization.yaml in a subdirectory in a repo on branch master/main
- kubectl apply -k https://github.com/lerndevops/educka/kustomize/demoapp
```
```
## kustomization.yaml in a subdirectory in a repo on branch test
- kubectl apply -k https://github.com/lerndevops/educka/kustomize/demoapp?ref=test
```
```
## kustomization.yaml in a subdirectory in a repo on commit `53aca40d4b9a98f1456869ec1197bae12b4119f1`
- kubectl apply -k https://github.com/lerndevops/educka/kustomize/demoapp?ref=53aca40d4b9a98f1456869ec1197bae12b4119f1
```