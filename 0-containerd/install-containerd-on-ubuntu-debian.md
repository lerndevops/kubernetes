## Install & Configure on Ubuntu / Debian

### Install 

``` 
sudo apt-get update
sudo apt-get -y install -y containerd
sudo containerd --version
```

### Configrue containerd 

```
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

vi /etc/containerd/config.toml ## ensure you see the setting as below if "false" change to true 
SystemdCgroup = true

sudo systemctl restart containerd
sudo systemctl status containerd
```

### FYI: important file paths

```
/etc/containerd/config.toml
/usr/bin/containerd
/usr/bin/containerd-shim
/usr/bin/containerd-shim-runc-v1
/usr/bin/containerd-shim-runc-v2
/usr/bin/ctr
/usr/bin/runc
/usr/lib/systemd/system/containerd.service
/usr/share/doc/containerd.io-1.4.4/README.md
/usr/share/licenses/containerd.io-1.4.4/LICENSE
/usr/share/man/man5/containerd-config.toml.5
/usr/share/man/man8/containerd-config.8
/usr/share/man/man8/containerd.8
/usr/share/man/man8/ctr.8
```
