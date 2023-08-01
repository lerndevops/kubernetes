## Extending the Kubernetes API

### Custom Resources

> **When we say Kubernetes, we typically think about deploying and managing containers. And while this is, in fact, Kubernetes’s main job, it can actually do much more than that. This is possible thanks to something called `custom resource definitions, or CRDs for short.`**

> **Custom Resource allows you to extend Kubernetes capabilities by adding any kind of API object useful for your application. Custom Resource Definition is what you use to define a Custom Resource. This is a powerful way to extend Kubernetes capabilities beyond the default installation.**

> **Custom resources can appear and disappear in a running cluster through dynamic registration, and cluster admins can update custom resources independently of the cluster itself. Once a custom resource is installed, users can create and access its objects using kubectl, just as they do for built-in resources like Pods.**

### simply crds

1) Make Kubernetes API more modular
2) Can be engaged with kubectl

### Some example use cases:

1) Provisioning/Management of external datastores/databases (eg. CloudSQL/RDS instances)
2) Higher level abstractions around Kubernetes primitives (eg. a single Resource to define an etcd cluster, backed by a Service and a ReplicationController)


### Custom controllers

> **Kubernetes has a very “pluggable” way to add your own logic in the form of a controller. `A controller` is a component that you can develop and run in the context of a Kubernetes cluster.**

> **Controllers are an essential part of Kubernetes. They are the “brains” behind the resources themselves. For instance, a Deployment resource for Kubernetes is tasked with making sure there is a certain amount of pods running. This logic can be found in the [deployment controller (GitHub)](https://github.com/kubernetes/kubernetes/blob/master/pkg/controller/deployment/deployment_controller.go).**

> ***You can have a custom controller without a custom resource (e.g. custom logic on native resource types).*** **Conversely, you can have custom resources without a controller, but that is a glorified data store with no custom logic behind it.**

> **we can write controller logic to manage existing kubernetes resources but, use-cases are limited**

> **The real power and flexibility with controllers is when you can start working with custom resources**

> **You can think of custom resources as the data, and controllers as the logic behind the data. Working together, they are a significant component to extending Kubernetes.**

### Define custom resource

> **When developing a custom resource (and controller) you will undoubtedly already have a requirement. The first step in defining the custom resource is to figure out the following…**

1) **The API group name — ex: extkube.io but this can be whatever you want**
2) **The version — ex: “v1” but you can use any that you like. For some ideas of existing API versions in your existing Kubernetes cluster you can run kubectl api-versions. Some common ones are “v1”, “v1beta2”, “v2alpha1”**
3) **Resource name — how your resource will be individually identified. For example: MyResource**

```
# Custom Resource Definition - CRD 
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: myresources.lernkube.io
spec:
  group: lernkube.io
  names:
    kind: MyResource
    plural: myresources
    singular: myresource
    shortNames:
      - mr
  scope: Namespaced
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        # schema used for validation
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                message:
                  type: string
                reason:
                  type: string
```
```
# Creating an Object using CRD
apiVersion: lernkube.io/v1
kind: MyResource
metadata:
  name: test-myresource
spec:
  message: "hello world"
  reason: "learning crds"
```

#### Note: Without a custrom Controller, a custom resource definition(CRD) is just data stored into your cluster store(ETCD)

## References

#### https://cloud.redhat.com/blog/kubernetes-deep-dive-code-generation-customresources
#### https://engineering.bitnami.com/articles/kubewatch-an-example-of-kubernetes-custom-controller.html
#### https://github.com/kubernetes/sample-controller
#### https://github.com/trstringer/k8s-controller-core-resource