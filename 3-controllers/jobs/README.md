## Jobs

> Kubernetes Jobs ensure that one or more pods execute their commands and exit successfully. 

> When all the pods have exited without errors, the Job gets completed. 

> When the Job gets deleted, any created pods get deleted as well.

### Lab

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
