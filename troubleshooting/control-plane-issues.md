## Control Plane Issues

### Check the events from the cluster for errors:
	kubectl get events
	kubectl get events -n kube-system
	kubectl get events -w
	kubectl cluster-info dump

### Get the logs from the individual pods in your kube-system namespace and check for errors:

	kubectl logs [kube_scheduler_pod_name] -n kube-system
	kubectl logs --since=1h [podname]
	kubectl logs --tail=20 [podname]
	kubectl logs -f -c [contname] [podname]
	watch kubectl logs kube-apiserver-kube-master -n kube-system

### Check the status of the Docker service:
	sudo systemctl status docker
	journalctl --unit docker

### Start up and enable the Docker service, so it starts upon bootup:
	sudo systemctl enable docker && systemctl start docker

### Check the status of the kubelet service:
	sudo systemctl status kubelet
	journalctl --unit kubelet

### Start up and enable the kubelet service, so it starts up when the machine is rebooted:
	sudo systemctl enable kubelet && systemctl start kubelet

### Turn off swap on your machine:
	sudo su -
	swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab

### Check if you have a firewall running:
	sudo systemctl status firewalld

### Disable the firewall and stop the firewalld service:
	sudo systemctl disable firewalld && systemctl stop firewalld

### View the syslogs:
	sudo more /var/log/syslog | tail -120 | grep kubelet
	sudo more /var/log/syslog | tail -120 | grep docker

[more Info](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/#a-general-overview-of-cluster-failure-modes)