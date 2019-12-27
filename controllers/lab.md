# Lab

### Replication Controllers 
```
create a manifest file with Kind ReplicationController & use kubectl to create the object in k8s API Server.

kubectl create -f rc-ex1.yml                # create replication Controller
kubectl apply -f rc-ex1.yml                 # udpate the replication Controller

kubectl get rc                              # List all replication Controllers in current active namespace
kubectl get rc -n <namespace>               # List the replication controllers in <namespace>
kubectl get rc --show-labels                # list the labels for rc
kubectl get rc -l rc=myapprc -o wide        # list replication controllers with matching labels
kubectl get pods | grep tomcatrc            # list the pods associated with rc
kubectl get rc tomcatrc -o yaml             # detailed object config
 
kubectl describe rc <rcname>                # inspect the replication controller
kubectl label rc <rcname> key=value         # label the replication controller
kubectl scale --replicas=x rc <rcname>      # Scale replication controller
kubectl expose rc <rcname> --port=<external> --target-port=<internal> # expose rc as service & assign port on the cluster
kubectl expose rc <rcname> --port=<external> --type=NodePort # expose rc as service & assign port on the Node
kubectl rolling-update tomcatrc -f rc-ex2.yml # roll update rc
kubectl delete rc <rcname>                  # delete rc & pod under it
```

### ReplicaSets
```
create a manifest file with Kind ReplicaSet & use kubectl to create the object in k8s API Server.

kubectl create -f rs-ex1.yml                # create replica set
kubectl apply -f rs-ex1.yml                 # update replica set

kubectl get rs                              # List all replica sets in current active namespace
kubectl get rs -n <namespace>               # List the replica sets in <namespace>
kubectl get rs --show-labels                # list the labels for rs
kubectl get rs -l rs=myapprs -o wide        # list replica sets with matching labels
kubectl get pods | grep tomcatrs            # list the pods associated with rs
kubectl get rs tomcatrs -o yaml             # detailed object config

kubectl describe rs <rsname>                # inspect the replica set
kubectl label rs <rsname> key=value         # label the replica set
kubectl scale --replicas=x rs <rsname>      # Scale up/down replica set
kubectl expose rs <rsname> --port=<external> --target-port=<internal> # expose rs as service & assign port on the cluster
kubectl expose rs <rsname> --port=<external> --type=NodePort # expose rs as service & assign port on the Node
kubectl delete rs <rsname>                  # delete rs & pod under it
```
### Deployments
```
create a manifest file with Kind ReplicaSet & use kubectl to create the object in k8s API Server.

kubectl create -f deployment-ex1.yml --record      # create deployment
kubectl apply -f deployment-ex1.yml  --record      # update the deployment 

kubectl get deploy                              # List all deployments in current active namespace
kubectl get deploy -n <namespace>               # List the deployments in <namespace>
kubectl get deploy --show-labels                # list the labels for deploy
kubectl get deploy -l deploy=myapprs -o wide    # list deployments with matching labels
kubectl get pods | grep mydeploy                # list the pods associated with deployment
kubectl get deploy mydeploy -o yaml             # detailed object config

kubectl describe deploy <deployment>                # inspect the deployment
kubectl label deploy <deployment> key=value         # label the deployment
kubectl scale --replicas=x deploy <deployment>      # Scale up/down deployment
kubectl expose deploy <deploy> --port=<external> --target-port=<internal> # expose deployment as service & assign port on the cluster
kubectl delete deploy <deployment>                  # delete deployment & pod under it

kubectl rollout history deploy <deployname>      # check the revisions of a Deployment
kubectl rollout history deploy <deployname> --revision=2   # see the details of each revision
kubectl rollout status deploy <deployname>       # get status of rollout 
kubectl rollout undo deploy <deployname>         # rollback to the previous revision
kubectl rollout undo deploy <deployname>  --revision=2     # rollback to a specific revision
kubectl rollout pause deploy <deployname>        # pause a Deployment before triggering one or more updates
kubectl rollout resume deploy <deployname>       
```
### DaemonSet
```
create a manifest file with Kind ReplicaSet & use kubectl to create the object in k8s API Server.

kubectl create -f ds-ex1.yml --record      # create daemonset
kubectl apply -f ds-ex1.yml  --record      # update the daemonset 

kubectl get ds                              # List all daemonsets in current active namespace
kubectl get ds -n <namespace>               # List the daemonsets in <namespace>
kubectl get ds --show-labels                # list the labels for daemonset
kubectl get ds -l ds=myds -o wide    # list daemonset with matching labels
kubectl get pods | grep myds               # list the pods associated with daemonset
kubectl get ds myds -o yaml             # detailed object config

kubectl describe ds <myds>                # inspect the daemonset
kubectl label ds <myds> key=value         # label the daemonset
kubectl expose ds <myds> --port=<external> --target-port=<internal> # expose rc as service & assign port on the cluster
kubectl delete ds <myds>                  # delete daemonset & pod under it
```
### Jobs
```
create a manifest file with Kind ReplicaSet & use kubectl to create the object in k8s API Server.

kubectl create -f job-ex1.yml --record      # create job
kubectl apply -f job-ex1.yml  --record      # update the job 

kubectl get jobs                              # List all jobs in current active namespace
kubectl get jobs -n <namespace>               # List the jobs in <namespace>
kubectl get jobs --show-labels                # list the labels for job
kubectl get jobs -o wide                      # list job with wider output
kubectl get pods | grep myjob                  # list the pods associated with jobs
kubectl get jobs myjob -o yaml                # detailed object config

kubectl describe job <myjob>                # inspect the job
kubectl label job <myjob> key=value         # label the job
kubectl delete job <myjob>                  # delete job & pod under it
```
### Cron Jobs
```
create a manifest file with Kind ReplicaSet & use kubectl to create the object in k8s API Server.

kubectl create -f cronjob-ex1.yml --record      # create cronjob
kubectl apply -f cronjob-ex1.yml  --record      # update the cronjob 

kubectl get cj                              # List all cronjob in current active namespace
kubectl get cj -n <namespace>               # List the cronjob in <namespace>
kubectl get cj --show-labels                # list the labels for cronjob
kubectl get cj -o wide                      # list cronjob with wider output
kubectl get cj | grep mycj                  # list the pods associated with cronjob
kubectl get cj mycj -o yaml                # detailed object config

kubectl describe cj <mycj>                # inspect the cronjob
kubectl label cj <mycj> key=value         # label the cronjob
kubectl delete cj <mycj>                  # delete cronjob & pod under it
```
