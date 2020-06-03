When building your application stack to work on Kubernetes, the basic pod configuration is usually done by setting different environment variables. Sometimes you want to configure just a few of them for a particular pod or to define a set of environment variables that can be shared by multiple pods. Later is usually done by creating a ConfigMap as a shared resource. Instead of specifying each environment variable individually we can reference the whole config map.

Set Environment Variables

To set the environment variables, you can use env or envFrom key in the configuration file. The most basic option is to set one or more of them using the simple key:value syntax:

	spec:
	  containers:
	  - env:
		- name: VARIABLE1
		  value: test1
		  
It looks okay, but imagine ten or more variables per pod. It would be much better to have a separate configuration file. In Kubernetes you can do that by utilizing config maps. Here is an example:

	apiVersion: v1
	kind: ConfigMap
	metadata:
	  name: my-env
	data:
	  VARIABLE1: test1
	  VARIABLE2: test2
	  VARIABLE3: test3

With the above configuration, it is easy for multiple containers to share the same set of environment variables. Then we need to reference the config map file with configMapRef (available from Kubernetes v1.6):

	spec:
	  containers:
	  - envFrom:
		  - configMapRef:
			  name: my-env

In case you don't want for each container to have all environment variables from the config map, you can get specific keys only. For example, get VARIABLE1 in the pod:

	spec:
	  containers:
	  - env:
		- name: VARIABLE1
		  valueFrom:
			configMapKeyRef:
			  name: my-env
			  key: VARIABLE1

Pod and Container Fields

Also, you can get pod and container fields that are available through Kubernetes API and set them as environment variables. Here is the list of available pod and container fields - replace <CONTAINER_NAME> with your container name to get container fields:

	spec:
	  containers:
	  - env:
		- name: MY_NODE_NAME
		  valueFrom:
			fieldRef:
			  fieldPath: spec.nodeName
		# Kubernetes 1.7+
		- name: MY_NODE_IP
		  valueFrom:
			fieldRef:
			  fieldPath: status.hostIP
		- name: MY_POD_NAME
		  valueFrom:
			fieldRef:
			  fieldPath: metadata.name
		- name: MY_POD_NAMESPACE
		  valueFrom:
			fieldRef:
			  fieldPath: metadata.namespace
		- name: MY_POD_IP
		  valueFrom:
			fieldRef:
			  fieldPath: status.podIP
		- name: MY_POD_SERVICE_ACCOUNT
		  valueFrom:
			fieldRef:
			  fieldPath: spec.serviceAccountName
		# Kubernetes 1.8+
		- name: MY_POD_UID
		  valueFrom:
			fieldRef:
			  fieldPath: metadata.uid
		- name: MY_CPU_REQUEST
		  valueFrom:
			resourceFieldRef:
			  containerName: <CONTAINER_NAME>
			  resource: requests.cpu
		- name: MY_CPU_LIMIT
		  valueFrom:
			resourceFieldRef:
			  containerName: <CONTAINER_NAME>
			  resource: limits.cpu
		- name: MY_MEM_REQUEST
		  valueFrom:
			resourceFieldRef:
			  containerName: <CONTAINER_NAME>
			  resource: requests.memory
		- name: MY_MEM_LIMIT
		  valueFrom:
			resourceFieldRef:
			  containerName: <CONTAINER_NAME>
			  resource: limits.memory
			  
As we can see, there are a lot of options available in Kubernetes when defining environment variables. You need to pick the right approach. If you want to manage sensitive information like passwords and other secrets, then you should use Secret instead of ConfigMap.