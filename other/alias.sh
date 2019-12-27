#!/bin/bash

# shopt -s expand_aliases

alias k="kubectl"
alias kgn="kubectl get nodes -o wide"
alias kgp="kubectl get pods -o wide" 
alias kgd="kubectl get deployment -o wide"
alias kgs="kubectl get svc -o wide"

# Describe K8S resources
alias kdp="kubectl describe pod"
alias kdd="kubectl describe deployment" 
alias kds="kubectl describe service"
alias kdn="kubectl describe node"
