#!/bin/bash

#### Remove if a cluster is already running
which kubeadm 

if [ $? -eq 0 ];then
     echo "found kubeadm & tools -- removing... "
     kubeadm reset -f 
else
     echo "kubeadm & tools not found - proceeding with installation"
fi

#### Remove any pre installed docker packages  

sudo apt-mark unhold docker-ce docker-ce-cli kubectl kubeadm kubelet
sudo apt-get remove -y docker docker.io containerd runc  docker-ce docker-ce-cli containerd.io kubeadm kubectl kubelet
sudo apt autoremove -y
cd /var/lib
sudo rm -r docker
sudo rm -r kubelet
cd /etc/cni
sudo rm -r net.d

#### Install Specific Docker version
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common 

## Add Dockers official GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update ; clear
echo "Available Docker Version for Install"
echo " "
sudo apt-get install -y docker-ce docker-ce-cli containerd.io --allow-downgrades

## Install a specific Version
#dcever="5:18.09.8~3-0~ubuntu-bionic"
#sudo apt-get install -y docker-ce="$dcever" docker-ce-cli=$dcever containerd.io --allow-downgrades

if [ $? -eq 0 ];then
     echo "docker-ce is successfully installed"
else
     echo "issue with docker-ce installation - process abort"
     exit 1
fi

sudo service docker start ; clear

echo " "

#### Install Kubernetes latest components

echo "starting the installation of k8s components (kubeadm,kubelet,kubectl) ...."
echo " "
sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update ; clear

echo "Available Kubeadm,kubelet,kubectl Versions to install as below"
echo " "
apt-cache madison kubeadm | head | awk '{print $1,$2,$3}'
echo "=================================="
apt-cache madison kubelet | head | awk '{print $1,$2,$3}'
echo "=================================="
apt-cache madison kubectl | head | awk '{print $1,$2,$3}'
echo " "
#kubever="1.19.1-00"
echo "Installing $kubever Version for kubeadm,kubelet,kubectl"
sudo apt-get install -y kubeadm kubelet kubectl

if [ $? -eq 0 ];then
     echo "kubelet, kubeadm & kubectl are successfully installed"
else
     echo "issue in installing kubelet, kubeadm & kubectl - process abort"
     exit 2
fi

sudo apt-mark hold kubelet kubeadm kubectl docker-ce docker-ce-cli
echo " "

#### k8s with weave pod network
sudo service docker stop
sudo service docker start
echo "initializing kubernetes master ... may take couple of minutes ...."
sudo kubeadm init --ignore-preflight-errors=all 
if [ $? -eq 0 ];then
   echo " "
   echo "kubernetes master initiazied successfully..."
   echo "setting up kube config for User `whoami` ......"
   sudo mkdir -p $HOME/.kube
   sudo rm $HOME/.kube/config
   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   sudo chown $(id -u):$(id -g) $HOME/.kube/config
else
   echo "cluster initilization failed - process abort..."
   exit 8
fi
echo " "
echo "Setting up weave pod network"
echo " "
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
sleep 30
echo " "
kubectl get nodes

