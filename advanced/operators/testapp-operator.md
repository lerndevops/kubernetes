## deploy testapp crd 
```
kubectl apply -f https://raw.githubusercontent.com/lerndevops/kubernetes/master/advanced/crds/testapp-crd.yaml
```
```
kubectl get crd | grep -i testapp
kubectl api-resources | grep -i testapp
```

## deploy testapp resource
```
kubectl apply -f https://raw.githubusercontent.com/lerndevops/kubernetes/master/advanced/crds/deploy-testapp-resource.yaml
```
```
kubectl get testapps
kubectl describe testapp testapp-sample
```

## deploy testapp custom controller 
```
kubectl apply -f https://raw.githubusercontent.com/lerndevops/kubernetes/master/advanced/crds/testapp-custom-controller.yaml
```
```
kubectl get all -n testapp-system 
kubectl describe testapp testapp-sample
```
```
kubectl get pods 
kubectl get deployments 
kubectl get services
```
