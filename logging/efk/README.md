# EFK (ElasticSearch - FluentD - Kibana )

### ElasticSearch

> ElasticSearch is a document-oriented database designed to store, retrieve, and manage document-oriented or semi-structured data. When you use Elasticsearch, you store data in JSON document form. Then, you query them for retrieval.

### FluentD

> Fluentd is a popular open-source data collector that runs on a machine to tail log files, filter and transform the log data, and deliver it to the Elasticsearch cluster, where it will be indexed and stored

### Kibana

> Kibana is an open source analytics and visualization platform designed to work with Elasticsearch. You use Kibana to search, view, and interact with data stored in Elasticsearch indices. You can easily perform advanced data analysis and visualize your data in a variety of charts, tables, and maps.

##  Steps to install EFK stack on kubernetes cluster

##  Pre-requisite 

> Since EFK is a heavy application - the cluster needs to be atleast 6 cpu x 10 GB memory with 30 GB storage. EFK stack is a good example to understand the concepts of Deployment, Statefulset and DaemonSet. Lets start installing EFK stack on kubernetes - 

* Create the namespace to install the stack 

` kubectl create ns kube-logging ` 

```
kubectl get ns kube-logging
NAME           STATUS   AGE
kube-logging   Active   11s
```

* Create persistent volumes and persistent volume claims

> Elasticsearch will need a persistent volume and a corresponding claim that will be attached to the 3 replicas that we will create. The files pv.yaml and pvc.yaml contains the definition of persistent volume and persistent volume claim respectively. 

` kubectl create -f pv.yaml -f pvc.yaml -n kube-logging `

> The output will show that 3 PVCs are **BOUND** to 3 PVs. 

~~~
kubectl get pv,pvc -n kube-logging 
NAME                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                              STORAGECLASS   REASON   AGE
persistentvolume/es-pv-0   10Gi       RWO            Retain           Bound    kube-logging/es-pvc-es-cluster-0                           9s
persistentvolume/es-pv-1   10Gi       RWO            Retain           Bound    kube-logging/es-pvc-es-cluster-1                           9s
persistentvolume/es-pv-2   10Gi       RWO            Retain           Bound    kube-logging/es-pvc-es-cluster-2                           9s

NAME                                        STATUS   VOLUME    CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/es-pvc-es-cluster-0   Bound    es-pv-0   10Gi       RWO                           9s
persistentvolumeclaim/es-pvc-es-cluster-1   Bound    es-pv-1   10Gi       RWO                           9s
persistentvolumeclaim/es-pvc-es-cluster-2   Bound    es-pv-2   10Gi       RWO                           9s

~~~

* Create elasticsearch Statefulset

> As elasticsearch acts as the default backend of fluentd aggregated logs, its important that we deploy elasticsearch as an application that maintains state. Fluentd will continuously push data to elasticsearch. To reduce any latency and to associate the elasticsearch replicas directly to fluentd, we use the concept of Headless service. By using headless service - the DNS of the elasticsearch pods will be - *STATEFULSET-NAME-STICKYIDENTIFIER.HEADLESS-SERVICE-NAME*, i.e. **es-cluster-0.elasticsearch**

> Lets install elasticsearch headless service first  - 

` kubectl create -f elasticsearch_svc.yaml`

```
kubectl get svc -n kube-logging
NAME            TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)             AGE
elasticsearch   ClusterIP   None         <none>        9200/TCP,9300/TCP   7s
```

> Install elasticsearch statefulset

` kubectl create -f elasticsearch_statefulset.yaml`

```
kubectl get pods -n kube-logging
NAME           READY   STATUS    RESTARTS   AGE
es-cluster-0   1/1     Running   0          21s
es-cluster-1   1/1     Running   0          14s
es-cluster-2   1/1     Running   0          8s
```

> Using port-forward, verify the status of statefulset deployment

` kubectl port-forward es-cluster-0 9200:9200 --namespace=kube-logging`

` curl http://localhost:9200/_cluster/state?pretty  `

> The output should be as below

```
curl http://localhost:9200/_cluster/state?pretty
{
  "cluster_name" : "k8s-logs",
  "compressed_size_in_bytes" : 351,
  "cluster_uuid" : "fDRfwLflQjuKeOLAXuPwLg",
  "version" : 3,
  "state_uuid" : "NkdqNF34SKq0bmIMHrG96Q",
  "master_node" : "28Vbx-gdR7CKje0oT1PFhA",
  "blocks" : { },
  "nodes" : {
    "4FNwm6qBS6qBZDDpMg4x9g" : {
      "name" : "es-cluster-2",
      "ephemeral_id" : "s182JiZdSHCYG8Ja-swyuA",
      "transport_address" : "192.168.1.192:9300",
      "attributes" : { }
    },
    "VwgBprBNTA6kDP1BUJs_Zg" : {
      "name" : "es-cluster-0",
      "ephemeral_id" : "IQmaLDsJRzWU9tY7JDiUQg",
      "transport_address" : "192.168.1.191:9300",
      "attributes" : { }
    },
    "28Vbx-gdR7CKje0oT1PFhA" : {
      "name" : "es-cluster-1",
      "ephemeral_id" : "lJFv0XwaShm_y8eIjuMf-g",
      "transport_address" : "192.168.2.178:9300",
      "attributes" : { }
    }
  },
```

* Install Kibana

` kubectl create -f kibana.yaml `

> The output now should be as below - 

~~~
kubectl get pods,svc -n kube-logging 
NAME                         READY   STATUS    RESTARTS   AGE
pod/es-cluster-0             1/1     Running   0          5m13s
pod/es-cluster-1             1/1     Running   0          5m6s
pod/es-cluster-2             1/1     Running   0          5m
pod/kibana-bd6f49775-zmt4g   1/1     Running   0          22s

NAME                    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
service/elasticsearch   ClusterIP   None           <none>        9200/TCP,9300/TCP   6m14s
service/kibana          NodePort    10.99.16.215   <none>        5601:32182/TCP      22s
~~~

> Get the nodeport from the kibana service, and visit the kibana dashboard on your browser using - http://EXTERNAL_IP:nodeport. Currently kibana is empty as there are no logs being pushed to elasticsearch. 

* Install FluentD daemonset 

> FluentD will be installed as daemonset as we need one instance of fluentD running on all nodes. In order to run it on master, the corresponding tolerations has to be added to the fluentd yaml definition. The fluentd daemonset will look for the elasticsearch service to push the logs to. As a part of the environment variables, we define the headless service DNS (elasticsearch.kube-logging.svc.cluster.local) and the port 9200 so that fluentd can push all logs to the elasticsearch backend. 

> FluentD will aggregate logs from all pods running in all namespaces. In order to provide fluentd the corresponding privileges, we have to create a RBAC policy for fluentd to fetch data from the "POD" resource and fetch pods from all "NAMESPACES". The file clusterrole-fluentd.yaml provides the necessary clusterrole definition. The file clusterrolebinding-fluentd.yaml will bind the clusterrole to a serviceaccount which will be used to run the fluentd daemonset. 

` kubectl create -f sa-fluentd.yaml -f clusterrole-fluentd.yaml -f clusterrolebinding-fluentd.yaml  `

Output should be as below - 

~~~
kubectl create -f sa-fluentd.yaml -f clusterrole-fluentd.yaml -f clusterrolebinding-fluentd.yaml
serviceaccount/fluentd created
clusterrole.rbac.authorization.k8s.io/fluentd created
clusterrolebinding.rbac.authorization.k8s.io/fluentd created
~~~

> Deploy the fluentd daemonset 

` kubectl create -f fluentd_daemonset.yaml `

> Below should be the output of the kube-logging namespace now 
~~~
kubectl get pods -n kube-logging
NAME                     READY   STATUS    RESTARTS   AGE
es-cluster-0             1/1     Running   0          16m
es-cluster-1             1/1     Running   0          16m
es-cluster-2             1/1     Running   0          15m
fluentd-dcstb            1/1     Running   0          20s
fluentd-kqmcd            1/1     Running   0          20s
fluentd-xr987            1/1     Running   0          20s
kibana-bd6f49775-zmt4g   1/1     Running   0          11m
~~~


* Refresh kibana dashboard to see if the logstash-* index patterns are getting created. 

> In Discovery section - use the index pattern as logstash-* with timestamp as the filter to view all the logs. 

* Cleanup 

` kubectl delete ns kube-logging`















