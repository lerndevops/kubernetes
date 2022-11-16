## Network Policies 

> A network policy is a specification of how groups of pods are allowed to communicate with each other and other network endpoints.

1.   Network policies allow you to specify which pods can talk to other pods. This helps when securing communication between pods, allowing you to identify `ingress` and `egress` rules. 
2.   we can apply a network policy to a pod by using pod or namespace selectors. 
3.   we can even choose a CIDR block range to apply the network policy

## Prerequisites

> Network policies are implemented by the network plugin, so we must be using a networking solution which supports NetworkPolicy. Ex: calico, canal provides these features ( in cka exam you may see canal already setup )

>  simply creating the resource without a controller to implement it will have no effect 

### By Default , all pods in the cluster can communicate with any other pod and reach out to any available IP.

### Network Policies allow you to limit what network traffic is allowed to and from pods in your cluster.

# Demo

## Setp1: Deploy Spring Java Application & MongoDB Pods 
```
kubectl apply -f https://raw.githubusercontent.com/lerndevops/educka/master/examples/springboot-mongo-app.yml
```

## Step2: access the Sping Java Application & write some data to mongo db

```
kubectl get services springboot-app-svc

use the NodPort to access the springboot java in the browser 
```

> this proves that the You are able to access application from app pods 

> app is able to communicate to mongodb pods & write the data to it

## Step3: Now lets block the request / traffic to springa app & mongo db using Network Policies
```
kubectl apply -f https://raw.githubusercontent.com/lerndevops/educka/master/6-networking/policies/deny-ingress-to-mongodb-and-springapp.yaml
```

## Step4: Now try to access application from browser it shoudn't respond 

```
kubectl get services springboot-app-svc

use the NodPort to access the springboot java in the browser 
```

> This proves we successfully block all ingress (incoming) traffic to spring app 


## Step5: Now lets allows ingress(incoming) traffic to spring java app fromm all using Network Policies 

```
kubectl apply -f https://raw.githubusercontent.com/lerndevops/educka/master/6-networking/policies/allow-ingress-to-springapp-from-all.yaml
```
```
kubectl get services springboot-app-svc

use the NodPort to access the springboot java in the browser
```

> This should allow the traffic to Spring java App & you should see the app in browser 

> But if you try to submit the data to DB it will not respond, we still need to allow traffic to mongodb 

## Step6: Now lets allow ingress(incoming) traffic to mongodb only from spring app pods using Network Policies 

```
kubectl apply -f https://raw.githubusercontent.com/lerndevops/educka/master/6-networking/policies/allow-ingress-to-mongodb-from-springapp.yaml
```

> Now we should be able to write the data to mongodb from spring java app