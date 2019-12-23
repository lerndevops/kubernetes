## Node Issues 

```
kubectl get nodes -o wide
kubectl describe node nodename
```
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

### View the syslogs:
	sudo more /var/log/syslog | tail -120 | grep kubelet
	sudo more /var/log/syslog | tail -120 | grep docker