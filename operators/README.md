## Operators in Kubernetes

> Kubernetes is designed for automation. Out of the box, you get lots of built-in automation from the core of Kubernetes. You can use Kubernetes to automate deploying and running workloads, and you can automate how Kubernetes does that.
Kubernetes’ controllers concept lets you extend the cluster’s behaviour without modifying the code of Kubernetes itself. Operators are clients of the Kubernetes API that act as controllers for a Custom Resource.

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


