## Install etcdctl: 

```
   export RELEASE="3.3.13"
   wget https://github.com/etcd-io/etcd/releases/download/v${RELEASE}/etcd-v${RELEASE}-linux-amd64.tar.gz
   tar xvf etcd-v${RELEASE}-linux-amd64.tar.gz
   cd etcd-v${RELEASE}-linux-amd64
   sudo mv etcdctl /usr/local/bin
````
## etcd snapshot explanation

> the idea is to create a snapshot of the etcd database. This is done by communicating with the running etcd instance in Kubernetes and asking it to create a snapshot. 
> in order to communicate with the etcd pod in Kubernetes, we need to:

```
	Use the host network in order to access 127.0.0.1:2379, where etcd is exposed (--network host)
	Specify the correct etcd API version as environment variable (--env ETCDCTL_API=3)
	The actual command for creating a snapshot (etcdctl snapshot save /backup/etcd-snapshot-latest.db)
		Some flags for the etcdctl command
		Specify where to connect to (--endpoints=https://127.0.0.1:2379)
		Specify certificates to use (--cacert=..., --cert=..., --key=...)
```	

## backup ETCD Data:

`mkdir /etcd-backup`

`ETCDCTL_API=3 etcdctl --endpoints=192.168.198.147:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key snapshot save /etcd-backup/etcd-snapshot-latest.db`

## remove /var/lib/etcd folder, delete couple of deployments/pods

## restore ETCD Data:

ETCDCTL_API=3 etcdctl snapshot restore /etcd-backup/etcd-snapshot-latest.db --initial-cluster etcd-restore=https://10.128.0.42:2380 --initial-advertise-peer-urls=https://10.128.0.42:2380 --name etcd-restore --data-dir /var/lib/etcd


# ETCD Operations 

`kubectl -n kube-system get pods` 

`kubectl -n kube-system get pod etcd-kube-master -o yaml`

`kubectl -n kube-system exec -it etcd-kube-master -- sh`

`netstat -anp | grep 2379`

`ETCDCTL_API=3 etcdctl --endpoints=192.168.198.147:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key member list`

`ETCDCTL_API=3 etcdctl --endpoints=192.168.198.147:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key get / --prefix --keys-only`

`ETCDCTL_API=3 etcdctl --endpoints=192.168.198.147:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key get /registry/serviceaccounts/default/default`

`ETCDCTL_API=3 etcdctl --endpoints=192.168.198.147:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key put /naresh/mykey myvalue`

`ETCDCTL_API=3 etcdctl --endpoints=192.168.198.147:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key get /naresh --prefix --keys-only`

`ETCDCTL_API=3 etcdctl --endpoints=192.168.198.147:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key watch /naresh`

```
etcdctl mk     /path/newkey some-data       # Create key
etcdctl set    /path/newkey some-data       # Create or update key
etcdctl update /path/key new-data           # Update key
etcdctl put    /path/key new-data
etcdctl rm     /path/key
etcdctl rm     /path --recursive
```
