## Pod CIDR conflicts

* Kubernetes sets up special overlay network for container to container communication.

* With isolated pod network, containers can get unique IPs and avoid port conflicts on a cluster. You can read more about Kubernetes networking model [here.](https://kubernetes.io/docs/concepts/cluster-administration/networking/#kubernetes-model)

* The problems arise when Pod network subnets start conflicting with host networks.

#### HOW THE FAILURE MANIFESTS ITSELF
* Pod to pod communication is disrupted with routing problems.
```
$ curl http://172.28.128.132:5000
curl: (7) Failed to connect to 172.28.128.132 port 5000: No route to host
```
#### HOW TO DIAGNOSE
* Start with a quick look at the allocated pod IP addresses:
```
$ kubectl get pods -o wide
NAME                       READY     STATUS    RESTARTS   AGE       IP               NODE
netbox-2123814941-f7qfr    1/1       Running   4          21h       172.28.27.2      172.28.128.103
netbox-2123814941-ncp3q    1/1       Running   4          21h       172.28.21.3      172.28.128.102
testbox-2460950909-5wdr4   1/1       Running   3          21h       172.28.128.132   172.28.128.101
```
* Compare host IP range with the kubernetes subnets specified in the apiserver:
```
$ ip addr list
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:2c:6c:50 brd ff:ff:ff:ff:ff:ff
    inet 172.28.128.103/24 brd 172.28.128.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe2c:6c50/64 scope link 
       valid_lft forever preferred_lft forever
```
* IP address range could be specified in your [CNI plugin](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/#cni) or [kubenet](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/#kubenet) pod-cidr parameter.

#### HOW TO FIX

* Double-check what RFC1918 private network subnets are in use in your network, VLAN or VPC and make certain that there is no overlap.

* Once you detect the overlap, update the Pod CIDR to use a range that avoids the conflict.
