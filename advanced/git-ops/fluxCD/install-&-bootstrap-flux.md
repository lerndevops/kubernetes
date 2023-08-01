install Flux CLI: 
------------------

curl -s https://fluxcd.io/install.sh | sudo bash

validate: flux --version


bootstrap flux-system & its components:
---------------------------------------

step1: create a GITHUB TOKEN for your github account

go through the document: https://github.com/lerndevops/labs/blob/master/git/how-to-create-github-access-token.pdf

step2: check the pre req & ensure its passed 

run: flux check --pre 

    root@kube-kind:~# flux check --pre
        ► checking prerequisites
        ✔ Kubernetes 1.25.0 >=1.20.6-0
        ✔ prerequisites checks passed


step3: bootstrap the flux services in kubernetes cluster

export GITHUB_TOKEN=<replace-the-token-genereated-as-per-above-step1>

flux bootstrap github \
  --context=kubernetes-admin@kubernetes \
  --owner=<YOUR-GITHUB-ACCOUNT-ID> \
  --repository=fluxdemo \
  --branch=main \
  --personal \
  --path=./clusters/staging

git clone https://github.com/lerndevops/fluxdemo


# Note: 
   1) --context: ensure to use the rite kubernetes cluter context as per your cluster - use kubectl config get-contexts to see contexts available 
   2) --owner: ensure to update owner value as per your github account name/id used to login on github.com page
   3) --repository: we can give any name here, flux will create a git repo with the name provided
   4) --branch: you can any specific branch here but we stick to main 
   5) --personal: since we useing our personal github account, can be changed to org according to requirement
   6) --path: its a folder structure inside the repo created above & is used by flux components running inside a kubernetes cluster & help sync your app repos & manages its own components as well  
