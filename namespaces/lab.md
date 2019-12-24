# Lab

## list / describe namespaces 
```
	kubectl get namespaces
	kubectl get namespaces default -o yaml
	kubectl get namespaces --show-labels
	kubectl describe namespaces default
	kubectl edit namespace default
```

## create namespaces
```
	kubectl create namespace development  ## commandline
	kubectl create -f namespace-prod.yml   ## declarative
```

## set up namespaces to work with
```
	* we can permanently save the namespace for all subsequent kubectl commands in that context
	kubectl config get-contexts
	kubectl config set-context --current --namespace=mynamespace
	kubectl config set-context dev --namespace=mynamespace-with-resource-quota
	kubectl config use-context dev
	
	# Validate it
	kubectl config view --minify | grep namespace:

	kubectl config delete-context dev
```
 
[configure access to clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)
