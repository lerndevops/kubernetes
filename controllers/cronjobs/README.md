## CronJobs

> A CronJob creates Jobs on a repeating schedule.

> One CronJob object is like one line of a crontab (cron table) file. It runs a job periodically on a given schedule, written in Cron format.

### Lab
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
