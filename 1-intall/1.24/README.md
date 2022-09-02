
## Step 1. Install Docker and Kube (RUN on Both Masster & Nodes)

### Install Docker: 
-------------------

##### sh installDocker.sh

### Install DockerCRI connector
------------------------------

##### sh installCRIDockerd.sh

### Install Kubernetes
----------------------

##### installK8S.sh


## Step 2. Initialize Master  (Run only on Master)

sudo kubeadm init --ignore-preflight-errors=all


    sudo mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
