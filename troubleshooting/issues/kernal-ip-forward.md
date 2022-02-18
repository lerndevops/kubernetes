> Kubernetes supports a variety of networking plugins and each one can fail in its own way

> At its core, Kubernetes relies on the [Netfilter](https://www.netfilter.org/) kernel module to set up low level cluster IP load balancing. This requires two critical modules, IP forwarding and bridging, to be on.

## Kernel IP forwarding
* IP forwarding is a kernel setting that allows forwarding of the traffic coming from one interface to be routed to another interface.

* This setting is necessary for Linux kernel to route traffic from containers to the outside world.

#### `HOW THE FAILURE MANIFESTS ITSELF`

* Sometimes this setting could be reset by a security team running periodic security scans/enforcements on the fleet, or have not been configured to survive a reboot. When this happens networking starts failing.

#### Pod to service connection times out:
```
* connect to 10.100.225.223 port 5000 failed: Connection timed out
* Failed to connect to 10.100.225.223 port 5000: Connection timed out
* Closing connection 0
curl: (7) Failed to connect to 10.100.225.223 port 5000: Connection timed out
```
#### Tcpdump could show that lots of repeated SYN packets are sent, but no ACK is received.

#### **`HOW TO DIAGNOSE`**
```
# check that  ipv4 forwarding is enabled
sysctl net.ipv4.ip_forward
# 0 means that forwarding is disabled
net.ipv4.ip_forward = 0
```
#### **`HOW TO FIX`**
```
# this will turn things back on a live server
sysctl -w net.ipv4.ip_forward=1
# on Centos this will make the setting apply after reboot
echo net.ipv4.ip_forward=1 >> /etc/sysconf.d/10-ipv4-forwarding-on.conf
```
