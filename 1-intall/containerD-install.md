# Configure required modules
# First load two modules in the current running environment and configure them to load on boot

sudo modprobe overlay

sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf

overlay

br_netfilter

EOF



# Configure required sysctl to persist across system reboots

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf

net.bridge.bridge-nf-call-iptables  = 1

net.ipv4.ip_forward                 = 1

net.bridge.bridge-nf-call-ip6tables = 1

EOF



# Apply sysctl parameters without reboot to current running enviroment

sudo sysctl --system

# Install containerd packages

sudo apt-get update 

sudo apt-get install -y containerd


# Create a containerd configuration file

sudo mkdir -p /etc/containerd

sudo containerd config default | sudo tee /etc/containerd/config.toml




# Set the cgroup driver for runc to systemd which is required for the kubelet.

vi  /etc/containerd/config.toml

      
# Around line 112, change the value for SystemCgroup from false to true.

            SystemdCgroup = true

# Restart containerd with the new configuration

sudo systemctl restart containerd
