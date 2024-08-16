#!/bin/bash

##########################################################
## To run execute the below command ######################
## sh <script-name>.sh <eks-cluster-name> <region-code> ##
##########################################################

#install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

#install eksctl
curl --silent --location https://github.com/weaveworks/eksctl/releases/latest/download/eksctl\_$(uname -s)\_amd64.tar.gz | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

#install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
helm version

#install eks and vpc
#eksctl create cluster --name $1 --region $2 --fargate --zones="${2}a","${2}b"
eksctl create cluster --name $1 --region $2 --zones="${2}a","${2}b"

#authentication
aws eks --region $2 update-kubeconfig --name $1

kubectl get node


# kubectl get pod | grep "Pending"