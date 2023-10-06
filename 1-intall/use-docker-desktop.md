# Install Docker Desktop

## Step-01: Introduction
1. Install Docker Desktop

## Step-02: Docker Desktop - Pricing, SignUp, Download
- [Docker Desktop Pricing](https://www.docker.com/pricing/)
- [SignUp Docker Hub](https://hub.docker.com/)
- [Download Docker Desktop](https://www.docker.com/products/docker-desktop/)

## Step-03: Install Docker Desktop 
### Step-03-01: MACOS: Install Docker Desktop 
```t
# Install Docker Desktop
Copy Docker dmg to Applications folder

# Create Docker Hub Account
https://hub.docker.com

# Signin Docker Desktop 
Open Docker Desktop and SignIn to Docker Hub
```
### Step-03-02: WINDOWS: Install Docker Desktop 
```t
# Download Docker Desktop
https://www.docker.com/products/docker-desktop/

# Install Docker Desktop on Windows
Run the "Docker Desktop Installer.exe"

# Create Docker Hub Account
https://hub.docker.com

# Signin Docker Desktop 
Open Docker Desktop and SignIn to Docker Hub

# Configure kubectl cli on Windows PATH
C:\Program Files\Docker\Docker\Resources\bin
```

## Step-04: Enable Kubernetes Cluster
- **Additional Reference:** [Docker Desktop - k8s Cluster](https://docs.docker.com/desktop/kubernetes/)
```t
# Enable Kubernetes Cluster
- Go to Settings -> Enable Kubernetes
- Apply and Restart
- Kubernetes Cluster Installation: Install
- Wait for 5 to 10 minutes for Kubernetes Cluster to come up
```

## Step-05: Configure kubeconfig for kubectl for Docker Desktop k8s Cluster
```t
# Verify if kubectl installed (Docker desktop should install kubectl automatically)
which kubectl

# Verify kubectl version
kubectl version 
kubectl version --short
kubectl version --client --output=yaml

# List Config Contexts
kubectl config get-contexts

# Config Current Context
kubectl config current-context

# Config Use Context (Only if someother context is present in current-context output)
kubectl config use-context docker-desktop

# List Kubernetes Nodes
kubectl get nodes
```

## Step-06: Verify if our k8s Cluster is functional with a Sample Application
```t
# Review Kubernetes Manifests
kubectl apply -f https://raw.githubusercontent.com/lerndevops/kubernetes/master/3-controllers/deployments/deployment-ex2.yml

# List k8s Deployments
kubectl get deploy

# List k8s pods
kubectl get pods

# List k8s Services
kubectl get svc

# Access Application
http://localhost:31300
or
http://127.0.0.1:31300

# Uninstall k8s Resources from Docker Desktop k8s cluster
kubectl delete -f https://raw.githubusercontent.com/lerndevops/kubernetes/master/3-controllers/deployments/deployment-ex2.yml

# List pods, svc, deploy
kubectl get pods
kubectl get svc
kubectl get deploy
```
