
## Step 1. Install Docker and Kube (RUN on Both Masster & Nodes)

### Install Docker: 
-------------------

 sh installDocker.sh

### Install DockerCRI connector
------------------------------

sh installCRIDockerd.sh

### Install Kubernetes
----------------------

installK8S.sh


## Step 2. Initialize Master  (Run only on Master)

sudo kubeadm init --ignore-preflight-errors=all


    sudo mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config


sudo kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" 


## Step3. Add the Nodes to Master

kubeadm token create --print-join-command 

    copy the kubeadm join token from master & run it on all nodes

    Ex: kubeadm join 10.128.15.231:6443 --token mks3y2.v03tyyru0gy12mbt \
           --discovery-token-ca-cert-hash sha256:3de23d42c7002be0893339fbe558ee75e14399e11f22e3f0b34351077b7c4b56
