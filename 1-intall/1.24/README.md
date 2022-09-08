
## Step 1. Install Docker and Kube (RUN on Both Masster & Nodes)

### Install Docker: 
-------------------

./installDocker.sh

### Install DockerCRI connector
------------------------------

./installCRIDockerd.sh

#### Now update cridockerd service and restart as below

vi /etc/systemd/system/cri-docker.service

--network-plugin=cni  --cni-bin-dir=/opt/cni/bin --cni-conf-dir=/etc/cni/net.d

![image](https://user-images.githubusercontent.com/36464863/189142998-bb999780-be58-458c-bba6-bf6a789affbd.png)


######(refs: https://github.com/Mirantis/cri-dockerd/blob/master/README.md)

systemctl daemon-reload

service cri-docker restart

service docker restart





### Install Kubernetes
----------------------

./installK8S.sh


## Step 2. Initialize Master  (Run only on Master)

sudo kubeadm init --cri-socket unix:///var/run/cri-dockerd.sock


    sudo mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config


sudo kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" 


## Step3. Add the Nodes to Master

kubeadm token create --print-join-command 

    copy the kubeadm join token from master & run it on all nodes

    Ex: kubeadm join 10.128.15.231:6443 --token mks3y2.v03tyyru0gy12mbt \
           --discovery-token-ca-cert-hash sha256:3de23d42c7002be0893339fbe558ee75e14399e11f22e3f0b34351077b7c4b56 --cri-socket unix:///var/run/cri-dockerd.sock
