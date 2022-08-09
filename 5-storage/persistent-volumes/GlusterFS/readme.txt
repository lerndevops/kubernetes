apt install software-properties-common
add-apt-repository ppa:gluster/glusterfs-7
apt update
apt install glusterfs-server
systemctl status glusterd.service 
gluster volume create myappvol transport tcp ip-172-31-6-79:/mnt/myapp force
gluster volume start myappvol
gluster volume info myappvol 

apiVersion: v1
kind: Endpoints
metadata:
  name: glusterfs-cluster
subsets:
- addresses:
  - ip: 3.141.38.8
  ports:
  - port: 9090
---
apiVersion: v1
kind: Service
metadata:
  name: glusterfs-cluster
spec:
  type: ClusterIP
  ports:
   - port: 9090
---
kind: PersistentVolume
apiVersion: v1 
metadata:
  name: gfs-pv
spec: 
  glusterfs:
    endpoints: glusterfs-cluster
    path: myappvol1
  capacity: 
    storage: 1Gi
  accessModes: 
    - ReadWriteMany
---
kind: PersistentVolumeClaim
apiVersion: v1 
metadata: 
  name: gfs-pvc 
spec: 
  volumeName: gfs-pv
  resources:
    requests: 
      storage: 1Gi
  accessModes:
    - ReadWriteMany
---
kind: Deployment
apiVersion: apps/v1
metadata:
  name: gfs-dep
  namespace: default
  #labels:  # optional
spec:
  replicas: 2   # if we do not mention the replicas it will create one pod & manages it
  selector: 
    matchLabels: 
      app: py   # if a pod is found with this label in the cluster it will be acquired by the controller 
  template:
    metadata:
      #name: init1 kube will create a randon names for each pod automatically 
      labels: # are mandatory - are like tags 
        app: py   ## here both key & value are your choice 
    spec:
      #nodeName: node01
      #nodeSelector: 
      #  role: db 
      #tolerations:  # node=withgpu:NoSchedule OR dbnode:NoExecute
      terminationGracePeriodSeconds: 0  ## 0 means forcefull shutdown 
      restartPolicy: Always  # Never 
      #initConainers:
      volumes: 
        - name: gfvol 
          persistentVolumeClaim: 
            claimName: gfs-pvc
      containers:   # app containers 
        - name: cont1 
          image: nginx:latest
          volumeMounts: 
            - name: gfvol 
              mountPath: /usr/share/nginx/html
          #ports:
          #resources:
          #env:
          #startupProbe:
          #livenessProbe: ## what happens if livenessProbe fails -- ans: it restarts the cont 
          #readinessPorbe:
     
apt install glusterfs-client
