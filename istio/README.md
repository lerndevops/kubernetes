## Deploy ISTIO 

```
1. kubectl apply -f https://raw.githubusercontent.com/lerndevops/educka/master/istio/istio-init-1.10.3.yml
2. kubectl apply -f https://raw.githubusercontent.com/lerndevops/educka/master/istio/kiali.yml
3. kubectl apply -f https://raw.githubusercontent.com/lerndevops/educka/master/istio/jaeger.yaml
4. kubectl apply -f https://raw.githubusercontent.com/lerndevops/educka/master/istio/prometheus.yaml
5. kubectl apply -f https://raw.githubusercontent.com/lerndevops/educka/master/istio/grafana.yaml
6. kubectl apply -f https://raw.githubusercontent.com/lerndevops/educka/master/istio/label-default-namespace.yml
```
## Deploy DemoApp

```
kubectl apply -f https://raw.githubusercontent.com/lerndevops/educka/master/istio/1-fleemanapp-full-stack.yml
```

## DemoApp issues resolution
```
kubectl apply -f https://raw.githubusercontent.com/lerndevops/educka/master/istio/resolution-1-fleemanapp-full-stack.yml
```
