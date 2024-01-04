### Setup the Load Balancer config as below
---
```sh
## Create a vm with min 1cpu 2gb ram to run a proxy/load balancer on any Cloud

## Install the Docker on the vm created above

## Install Docker
sudo wget https://raw.githubusercontent.com/lerndevops/labs/master/scripts/installDocker.sh -P /tmp
sudo chmod 755 /tmp/installDocker.sh
sudo bash /tmp/installDocker.sh
sudo systemctl restart docker.service
```
```sh
vim /etc/nginx/nginx.conf
```
```sh
# put the below content in nginx.conf file

events { }
stream {
	upstream stream_backend {
		least_conn;
		# REPLACE WITH master0 IP
		server 10.128.0.2:6443;
		# REPLACE WITH master1 IP
		#server 192.168.122.161:6443;
		# REPLACE WITH master2 IP
		#server 192.168.122.162:6443;
	}
	server {
		listen        443;
		proxy_pass    stream_backend;
		proxy_timeout 3s;
		proxy_connect_timeout 1s;
	}
}
```
```sh
## run the proxy server using nginx image
	
docker run --name proxy -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf:ro -p 443:443 -d nginx
```
### initialize the first control plane node using below config 
---
```sh
cd $HOME
vim init-config.yaml
```
```yaml
## add the below in init-config.yaml
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: 1.28.1
# REPLACE with `loadbalancer` IP
controlPlaneEndpoint: "10.182.0.6:443"
---
kind: InitConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
nodeRegistration:
  criSocket: unix:///var/run/cri-dockerd.sock
```
```sh
## initialize the kubernetes control plane
kubeadm init --config $HOME/init-config.yaml --upload-certs
```
### initialize the second & third control plane nodes using below syntax 
---
```sh
## To add another control plane (master) node, a user can run the following command.

kubeadm join ${API_SERVER_PROXY_IP}:${API_SERVER_PROXY_PORT} \
    --control-plane --certificate-key=${ENCRYPTION_KEY} \
    --token ${KUBEADM_TOKEN} \
    --discovery-token-ca-cert-hash ${APISERVER_CA_CERT_HASH}
    --cri-socket ${CRI_SOCKET}
```
```sh
# example
## we can join the second & third Control-Plane as below 

sudo kubeadm join 10.182.0.6:443 --token gjlgud.gkyc42ps0jhfq2gf \
--discovery-token-ca-cert-hash sha256:25f1ccba123333fc888d28f7b099a2af46434fdd75efb329303c495976c06558 \
--control-plane --certificate-key f11f7879e167aafe60c66947061e7eed96289769a550164aca9b201613dd07ae \
--cri-socket unix:///var/run/cri-dockerd.sock
```
