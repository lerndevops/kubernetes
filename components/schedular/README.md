# kubernetes-multiple-scheduler


The Kubernetes scheduler is a policy-rich, topology-aware, workload-specific function that significantly impacts availability, performance, and capacity. The scheduler needs to take into account individual and collective resource requirements, quality of service requirements, hardware/software/policy constraints, affinity and anti-affinity specifications, data locality, inter-workload interference, deadlines, and so on. Workload-specific requirements will be exposed through the API as necessary.


Kubernetes ships with its default scheduler. Please refer to the architecture discussion about what scheduler does. 

The source code for kubernetes defaule scheduler is - 
https://github.com/kubernetes/kubernetes/tree/master/pkg/scheduler


We will take reference from the official kubernetes documentation to implement a second scheduler which will be a replica of the default scheduler. We will name the new scheduler as - **myscheduler** adn the default scheduler will be named as **default-scheduler**. The original demo is referenced at - https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/

**Note** that for this demo we will be building kubernetes on the master node. It is highly recommended that you have atleast 6 CPU, 15 GB of memory and 30 GB of storage on the node where you will execute the **make** command 


Lets start off by 

* Build kubernetes from source

**Clone the official github repository**

```
git clone https://github.com/kubernetes/kubernetes.git
```

**Install build essentials package for ubuntu**

```
sudo apt-get install build-essential -y
```

**Install GO version 1.12.9**

```
mkdir goinstall
cd goinstall
wget https://dl.google.com/go/go1.12.9.linux-amd64.tar.gz
tar -C /usr/local/ -xzf go1.12.9.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
echo "export GOPATH=$HOME/go" >> ~/.profile
source ~/.profile

```

**Build Kubernetes** 

```
mkdir -p $GOPATH/src/k8s.io

cd $GOPATH/src/k8s.io

git clone https://github.com/kubernetes/kubernetes

cd kubernetes

make
```

The output is generated at - 

```
root@master:~/go/src/k8s.io/kubernetes# ls -ltra _output/local/bin/linux/amd64/
total 1636344
drwxr-xr-x 3 root root      4096 Oct 31 19:30 ..
-rwxr-xr-x 1 root root   4776910 Oct 31 19:30 go2make
-rwxr-xr-x 1 root root   6722368 Oct 31 19:30 deepcopy-gen
-rwxr-xr-x 1 root root   6689632 Oct 31 19:30 defaulter-gen
-rwxr-xr-x 1 root root   6738848 Oct 31 19:30 conversion-gen
-rwxr-xr-x 1 root root  11357344 Oct 31 19:30 openapi-gen
-rwxr-xr-x 1 root root   2067328 Oct 31 19:30 go-bindata
-rwxr-xr-x 1 root root  46484960 Oct 31 19:36 kubectl
-rwxr-xr-x 1 root root 209533816 Oct 31 19:36 genkubedocs
-rwxr-xr-x 1 root root   1648224 Oct 31 19:36 mounter
-rwxr-xr-x 1 root root  45794912 Oct 31 19:36 genyaml
-rwxr-xr-x 1 root root 120510976 Oct 31 19:36 kube-controller-manager
-rwxr-xr-x 1 root root   8466464 Oct 31 19:36 genswaggertypedocs
-rwxr-xr-x 1 root root  40242464 Oct 31 19:36 kube-proxy
-rwxr-xr-x 1 root root 133733920 Oct 31 19:36 e2e.test
-rwxr-xr-x 1 root root   8814784 Oct 31 19:36 ginkgo
-rwxr-xr-x 1 root root 216607640 Oct 31 19:36 genman
-rwxr-xr-x 1 root root  45794912 Oct 31 19:36 gendocs
-rwxr-xr-x 1 root root 121305336 Oct 31 19:36 kubemark
-rwxr-xr-x 1 root root  44882368 Oct 31 19:36 kube-scheduler
-rwxr-xr-x 1 root root   5483328 Oct 31 19:36 linkcheck
-rwxr-xr-x 1 root root 174141152 Oct 31 19:36 kube-apiserver
-rwxr-xr-x 1 root root  44098272 Oct 31 19:36 kubeadm
-rwxr-xr-x 1 root root 194604032 Oct 31 19:36 e2e_node.test
-rwxr-xr-x 1 root root   1987648 Oct 31 19:36 go-runner
-rwxr-xr-x 1 root root  50129472 Oct 31 19:36 apiextensions-apiserver
-rwxr-xr-x 1 root root 122934520 Oct 31 19:36 kubelet

```

---

* Create a docker image of the new scheduler 

```
vi Dockerfile 
```

Add the below content to dockerfile and save 

```
FROM busybox
ADD ./_output/local/bin/linux/amd64/kube-scheduler /usr/local/bin/kube-scheduler

```

Login to your docker account 

```
docker login
```

Build the docker image 

```
docker build . -t YOUR_DOCKER_ID/kube:my-schedular

# In my case it is - 

docker build . -t lerndevops/kube:my-schedular
```

Push the image to dockerhub

```
docker push YOUR_DOCKER_ID/kube:my-schedular

# In my case it is 

docker push lerndevops/kube:my-schedular

The push refers to repository [docker.io/lerndevops/kube:my-schedular]
6c7a72d53921: Pushed 
1da8e4c8d307: Mounted from library/busybox 
1.0: digest: sha256:b124f38ea2bc80bf38175642e788952be1981027a5668e596747da3f4224c299 size: 739

```

---

* Deploy the new scheduler 

Create a file - my-scheduler.yaml 

```
vi my-scheduler.yaml
```

Add the below content and change the image to point to your docker hub image. Save the file after the change 

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-scheduler
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: my-scheduler-as-kube-scheduler
subjects:
- kind: ServiceAccount
  name: my-scheduler
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: system:kube-scheduler
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    component: scheduler
    tier: control-plane
  name: my-scheduler
  namespace: kube-system
spec:
  selector:
    matchLabels:
      component: scheduler
      tier: control-plane
  replicas: 1
  template:
    metadata:
      labels:
        component: scheduler
        tier: control-plane
        version: second
    spec:
      serviceAccountName: my-scheduler
      containers:
      - command:
        - /usr/local/bin/kube-scheduler
        - --address=0.0.0.0
        - --leader-elect=false
        - --scheduler-name=my-scheduler
        image: gcr.io/my-gcp-project/my-kube-scheduler:1.0
        livenessProbe:
          httpGet:
            path: /healthz
            port: 10251
          initialDelaySeconds: 15
        name: kube-second-scheduler
        readinessProbe:
          httpGet:
            path: /healthz
            port: 10251
        resources:
          requests:
            cpu: '0.1'
        securityContext:
          privileged: false
        volumeMounts: []
      hostNetwork: false
      hostPID: false
      volumes: []

```

Verify that - 

Name is kept as **my-scheduler**

Also note also that we created a dedicated service account my-scheduler and bind the cluster role system:kube-scheduler to it so that it can acquire the same privileges as kube-scheduler.

Run the new scheduler 

```
kubectl create -f my-scheduler.yaml

#Output
deployment.apps/my-scheduler created

```

Add the service account of my-scheduler to the clusterrolebinding **system:volume-scheduler**

```
kubectl edit clusterrolebinding system:volume-scheduler

# Add the below lines at the end of the file

- kind: ServiceAccount
  name: my-scheduler
  namespace: kube-system

```

Verify that both schedulers are running 

```
kubectl get pods --namespace=kube-system | grep scheduler
kube-scheduler-master                     1/1     Running   1          81m
my-scheduler-5854749c67-4n7r8             1/1     Running   0          60s
```

---

* Specifying scheduler for pods 

Note that when no scheduler name is specified, the kubernetes uses the **default-scheduler** 

For this demo we will create a pod that uses the newly created scheduler 

Create a file pod.yaml with the below content - 

```
vi pod.yaml 

# Add the below content 

apiVersion: v1
kind: Pod
metadata:
  name: myschedulerdemo
  labels:
    name: multischeduler-example
spec:
  schedulerName: my-scheduler
  containers:
  - name: cont
    image: nginx

```

Create the pod using - 

```
kubectl create -f pod.yaml

# Output
pod/myschedulerdemo created

```

Verify that pod was created and was created using **my-scheduler** by running kubectl get events

```
<unknown>   Normal   Scheduled                 pod/myschedulerdemo           Successfully assigned default/myschedulerdemo to slave

```






