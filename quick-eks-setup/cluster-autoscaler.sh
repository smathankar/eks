#https://github.com/helm/charts/tree/master/stable/cluster-autoscaler

helm install stable/cluster-autoscaler --name my-release --set autoDiscovery.clusterName=<CLUSTER NAME>