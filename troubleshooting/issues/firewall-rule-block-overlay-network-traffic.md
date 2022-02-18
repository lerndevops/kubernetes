## Firewall rules block overlay network traffic
* Kubernetes provides a variety of networking plugins that enable its clustering features while providing backwards compatible support for traditional IP and port based applications.

* One of most common on-premises Kubernetes networking setups leverages a VxLAN overlay network, where IP packets are **encapsulated in UDP and sent over port 8472.**

#### HOW THE FAILURE MANIFESTS ITSELF
* There is 100% packet loss between pod IPs either with lost packets or destination host unreachable.
```
$ ping 10.244.1.4 
PING 10.244.1.4 (10.244.1.4): 56 data bytes
^C--- 10.244.1.4 ping statistics ---
5 packets transmitted, 0 packets received, 100% packet loss
```
#### HOW TO DIAGNOSE
* It is better to use the same protocol to transfer the data, as firewall rules can be protocol specific, e.g. could be blocking UDP traffic.

* `**iperf**` could be a good tool for that:
```
#  on the server side
iperf -s -p 8472 -u
# on the client side 
iperf -c 172.28.128.103 -u -p 8472 -b 1K
```
#### HOW TO FIX
* Update the firewall rule to stop blocking the traffic. Here is some [common iptables advice.](https://serverfault.com/questions/696182/debugging-iptables-and-common-firewall-pitfalls)
