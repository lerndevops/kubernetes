## get cluster status 
```
kubectl get componentstatus  # get schedular / etcd / controller manager status
kubectl cluster-info         # Display addresses of the master and services
```
## dump cluster state
```
kubectl cluster-info dump                                             # Dump current cluster state to stdout
kubectl cluster-info dump --output-directory=/path/to/cluster-state   # Dump current cluster state to /path/to/cluster-state
```
