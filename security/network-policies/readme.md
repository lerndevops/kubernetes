# Network Policies 

> A network policy is a specification of how groups of pods are allowed to communicate with each other and other network endpoints.

1.   Network policies allow you to specify which pods can talk to other pods. This helps when securing communication between pods, allowing you to identify `ingress` and `egress` rules. 
2.   we can apply a network policy to a pod by using pod or namespace selectors. 
3.   we can even choose a CIDR block range to apply the network policy

## Prerequisites

> Network policies are implemented by the network plugin, so we must be using a networking solution which supports NetworkPolicy. Ex: calico, canal provides these features ( in cka exam you may see canal already setup )
>  simply creating the resource without a controller to implement it will have no effect 

## Network Policy - Deny All

` kubectl apply -f deny-all.yml `

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

### validate by create a deployment 

   `kubectl apply -f deployment.yml`

   ```
     kubectl get pods -o wide  ## make note pod ips

     ## ping the second POD IP from first POD & vice versa
     kubect exec pod alpine-5c67c48d59-d5m27 -- ping -c3 192.168.9.65
     
     due to the NetworkPliciy deny-all, it should not be get any response back
   ```

   ```
   root@kube-master:# kubectl exec alpine-5c67c48d59-d5m27 -- ping -c3 192.168.9.124
   PING 192.168.9.124 (192.168.9.124): 56 data bytes
   --- 192.168.9.124 ping statistics ---
   3 packets transmitted, 0 packets received, 100% packet loss
   command terminated with exit code 1
   ```

## Network Policy Pod Seclector

` kubectl apply -f podSelector-NetPolicy.yml `
   
```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-netpolicy
spec:
  podSelector:
    matchLabels:
      app: db
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: web
```

### validate 

   ``` 
   root@kube-master:~# kubectl get pods -o wide
   NAME                     READY   STATUS    RESTARTS   AGE   IP              NODE         
   alpine-66f845d86-kcjwl   1/1     Running   0          22m   192.168.9.65    kube-node1          
   alpine-66f845d86-s2s97   1/1     Running   0          22m   192.168.9.127   kube-node1          

   ## label the first pod with app=db
   kubectl label pods alpine-66f845d86-kcjwl app=db
   
   ## label the second pod with app=web
   kubectl lebel pods alpine-66f845d86-s2s97 app=web
   
   root@kube-master:/home/educka/security# kubectl get pods --show-labels
   NAME                     READY   STATUS    RESTARTS   AGE   LABELS
   alpine-66f845d86-kcjwl   1/1     Running   0          29m   app=db,tier=frontend
   alpine-66f845d86-s2s97   1/1     Running   0          29m   app=web,tier=frontend

   ```

   ***as per the network policy, we set ingress rule on app=db labeled pods shold accept the traffic only from the pods which have lables app=web***

   ``` 
   ## ping db pod from web pod
      kubectl exec alpine-66f845d86-s2s97 -- ping -c1 192.168.9.65 ## it should respond  
   
   ## ping web pod from db pod 
      kubectl exec alpine-66f845d86-kcjwl -- ping -c1 192.168.9.127 ## it should not respond
   ```
