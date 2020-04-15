# Install K8s: CentOS 18 LTS WITH 2 CPUS & 4GB RAM

### Install Docker

`sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine docker-ce docker-ce-cli containerd.io`

`sudo yum install -y yum-utils device-mapper-persistent-data lvm2`

`sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`

`sudo yum install -y docker-ce docker-ce-cli containerd.io`

`systemctl enable --now docker`

`systemctl start docker`

### Install kubeadm,kubelet,kubectl

```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```
##### Set SELinux in permissive mode (effectively disabling it)

`setenforce 0`

`sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config`

`yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes`

`systemctl enable --now kubelet`
