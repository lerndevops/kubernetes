## AWS source/destination check is turned on
* AWS performs [source destination check](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#change_source_dest_check) by default. This means that AWS checks if the packets going to the instance have the target address as one of the instance IPs.

* Many Kubernetes networking backends use target and source IP addresses that are different from the instance IP addresses to create [Pod overlay networks.](https://kubernetes.io/docs/concepts/cluster-administration/networking/#kubernetes-model)

#### HOW THE FAILURE MANIFESTS ITSELF
* Sometimes this setting could be changed by Infosec setting account-wide policy enforcements on the entire AWS fleet and networking starts failing:

* Pod to service connection times out:
```
* connect to 10.100.225.223 port 5000 failed: Connection timed out
* Failed to connect to 10.100.225.223 port 5000: Connection timed out
* Closing connection 0
curl: (7) Failed to connect to 10.100.225.223 port 5000: Connection timed out
```
* Tcpdump could show that lots of repeated SYN packets are sent, without a corresponding ACK anywhere in sight.

#### HOW TO DIAGNOSE AND FIX
Turn off source destination check on cluster instances following [this guide.](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#change_source_dest_check)
