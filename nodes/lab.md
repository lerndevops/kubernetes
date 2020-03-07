## Lab
```
kubectl get nodes                    # get list of node in the cluster
kubectl get nodes -o wide            # get list of node in the cluster with wider output
kubectl describe node kube-node      # describe a node for detailed output

kubectl get node --selector='!node-role.kubernetes.io/master'  # Get all worker nodes

kubectl get nodes --show-labels      # display the labes for a all nodes in the cluster
kubectl label node kube-node env=prod # label the nodes
kubectl get node --selector='env=prod' # get all node with env=prod

kubectl taint nodes node1 key=value:NoSchedule  #  places a taint on node node1. The taint has key key, value value, and taint effect NoSchedule. This means that no pod will be able to schedule onto node1 unless it has a matching toleration
kubectl taint nodes node1 key:NoSchedule-  # to remove the taint

kubectl get node kube-node -o yaml   # view the node configuration yaml
kubectl edit node kube-node          # edit & apply the node configuration 

kubectl cordon kube-node             # Mark kube-node as unschedulable & doesn't disturb the existing workloads
kubectl drain kube-node              # Drain kube-node in preparation for maintenance, removes all the pods from drained node
kubectl drain kube-node --ignore-daemonsets --force  
kubectl uncordon kube-node           # Mark kube-node as schedulable
kubectl delete node kube-node        # remove node from cluster
```
