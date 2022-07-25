> An industry-standard container runtime with an emphasis on simplicity, robustness and portability.

> containerd is available as a daemon for Linux and Windows. 

> It manages the complete container lifecycle of its host system, from image transfer and storage to container execution and supervision to low-level storage to network attachments and beyond.

## containerd setup  

### Install & Configure on Ubuntu / Debian

```
## Install 

sudo apt-get update
sudo apt-get -y install -y containerd
sudo containerd --version
```

```
## Configrue containerd 

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl status containerd
```

### Install & Configure on CentOS/Amzn/RedHat/Fedora

```
## Install 

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install containerd.io -y
sudo systemctl enable containerd
sudo systemctl start containerd
sudo containerd --version

```

```
## Configrue containerd 

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl status containerd
```


#### FYI

> modprobe is a Linux program originally written by Rusty Russell and used to add a loadable kernel module to the Linux kernel or to remove a loadable kernel module from the kernel.

> sysctl is used to modify kernel parameters at runtime OR sysctl is a software utility of some Unix-like operating systems that reads and modifies the attributes of the system kernel such as its version number, maximum limits, and security settings. 
