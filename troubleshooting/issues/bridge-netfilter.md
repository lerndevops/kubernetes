## Bridge Netfilter

* The bridge-netfilter setting enables [iptables rules to work on Linux bridges](http://ebtables.netfilter.org/br_fw_ia/br_fw_ia.html#section4) just like the ones set up by Docker and Kubernetes.

* This setting is necessary for the Linux kernel to be able to perform address translation in packets going to and from hosted containers.

#### HOW THE FAILURE MANIFESTS ITSELF
* Network requests to services outside the Pod network will start timing out with destination host unreachable or connection refused errors.

#### HOW TO DIAGNOSE
```
# check that bridge netfilter is enabled
sysctl net.bridge.bridge-nf-call-iptables

# 0 means that bridging is disabled
net.bridge.bridge-nf-call-iptables = 0
```
#### HOW TO FIX
```
# Note some distributions may have this compiled with kernel,
# check with cat /lib/modules/$(uname -r)/modules.builtin | grep netfilter
modprobe br_netfilter
# turn the iptables setting on
sysctl -w net.bridge.bridge-nf-call-iptables=1
echo net.bridge.bridge-nf-call-iptables=1 >> /etc/sysconf.d/10-bridge-nf-call-iptables.conf
```
