## What is an Operator?
> Whenever we deploy our application on Kubernetes we leverage multiple Kubernetes objects like deployment, service, role, ingress, config map, etc. 

> As our application gets complex and our requirements become non-generic, managing our application only with the help of native Kubernetes objects becomes difficult and we often need to introduce manual intervention or some other form of automation to make up for it.

> Operators solve this problem by making our application first class Kubernetes objects that is we no longer deploy our application as a set of native Kubernetes objects but a custom object/resource of its kind

> **Operators combine crds and custom controllers and intend to eliminate the requirement for manual intervention (human operator) while performing tasks like an upgrade, handling failure recovery, scaling in case of complex (often stateful) applications and make them more resilient and self-sufficient.**

## How to Build Operators ?

> For building and managing operators we mostly leverage the [Operator Framework](https://github.com/operator-framework) which is an open source tool kit allowing us to build operators in a highly automated, scalable and effective way.  

> **Operator framework comprises of two subcomponents:**

1. **`Operator SDK:`** Operator SDK is the most important component of the operator framework. It allows us to bootstrap our operator project in minutes. It exposes higher level APIs and abstraction and saves developers the time to dig deeper into kubernetes APIs and focus more on building the operational logic. It performs common tasks like getting the controller to watch the custom resource (cr) for changes etc as part of the project setup process.

2. **`Operator Lifecycle Manager:`**  Operators also run on the same kubernetes clusters in which they manage applications and more often than not we create multiple operators for multiple applications. Operator lifecycle manager (OLM) provides us a declarative way to install, upgrade and manage all the operators and their dependencies in our cluster.

## Types of Operators

>> **Currently there are three different types of operator we can build:**

1. **`Helm based operators:`** Helm based operators allow us to use our existing Helm charts and build operators using them. Helm based operators are quite easy to build and are preferred to deploy a stateless application using operator pattern.

2. **`Ansible based Operator:`** Ansible based operator allows us to use our existing ansible playbooks and roles and build operators using them. There are also easy to build and generally preferred for stateless applications.

3. **`Go based operators:`** Go based operators are built to solve the most complex use cases and are generally preferred for stateful applications. In case of an golang based operator, we build the controller logic ourselves providing it with all our custom requirements. This type of operators is also relatively complex to build.


![Operator Maturity Model](https://github.com/lerndevops/kubernetes/blob/master/static/operator.webp)

### An example Operator

```
Some of the things that you can use an operator to automate include:
		deploying an application on demand
		taking and restoring backups of that application’s state
		handling upgrades of the application code alongside related changes such as database schemas or extra configuration settings
		publishing a Service to applications that don’t support Kubernetes APIs to discover them
		simulating failure in all or part of your cluster to test its resilience
		choosing a leader for a distributed application without an internal member election process
What might an Operator look like in more detail? Here’s an example in more detail:
	1.	A custom resource named SampleDB, that you can configure into the cluster.
	2.	A Deployment that makes sure a Pod is running that contains the controller part of the operator.
	3.	A container image of the operator code.
	4.	Controller code that queries the control plane to find out what SampleDB resources are configured.
	5.	The core of the Operator is code to tell the API server how to make reality match the configured resources.
		If you add a new SampleDB, the operator sets up PersistentVolumeClaims to provide durable database storage, a StatefulSet to run SampleDB and a Job to handle initial configuration.
		If you delete it, the Operator takes a snapshot, then makes sure that the StatefulSet and Volumes are also removed.
	6.	The operator also manages regular database backups. For each SampleDB resource, the operator determines when to create a Pod that can connect to the database and take backups. These Pods would rely on a ConfigMap and / or a Secret that has database connection details and credentials.
	7.	Because the Operator aims to provide robust automation for the resource it manages, there would be additional supporting code. For this example, code checks to see if the database is running an old version and, if so, creates Job objects that upgrade it for you.
```

### Deploying Operators

> The most common way to deploy an Operator is to add the Custom Resource Definition and its associated Controller to your cluster. The Controller will normally run outside of the control plane, much as you would run any containerized application. For example, you can run the controller in your cluster as a Deployment.

`https://operatorhub.io/getting-started`


