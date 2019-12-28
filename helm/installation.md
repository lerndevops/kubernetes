    wget https://storage.googleapis.com/kubernetes-helm/helm-v2.12.0-rc.2-linux-amd64.tar.gz
    tar -zxvf helm-v2.12.0-rc.2-linux-amd64.tar.gz

    cp linux-amd64/helm /usr/bin/
    
    helm init
    
    kubectl create serviceaccount --namespace kube-system tiller

    kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

    kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
    
    
