## deploy kubernetes dashboard with NodePort ##########################

## Add inbound rule to Nodes SG:
## 443            0.0.0.0/0 
## 30000-32767    0.0.0.0/0 

## Access the k8s dashboard using https://<Anyone node public ip>:<auto assigned port of service kubernetes-dashboard-kong-proxy>
## eg:   https://54.90.107.230:30717/


## adding helm repo
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

sleep 5

## deploy k8s dashboard
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard


sleep 20


## creating 
cat >> values.yaml<<EOF
kong:
  proxy:
    type: NodePort
  http:
    enabled: true
EOF


## `kubernetes-dashboard-kong-proxy` to `NodePort` from `ClusterIP` and enable its HTTP connection.
helm upgrade kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -f values.yaml -n kubernetes-dashboard

sleep 5

## create user.yaml
cat >> user.yaml<<EOF
apiVersion: v1
kind: ServiceAccount
metadata:  
  name: admin-user  
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:  
  name: admin-user
roleRef:  
  apiGroup: rbac.authorization.k8s.io  
  kind: ClusterRole  
  name: cluster-admin
subjects:
- kind: ServiceAccount  
  name: admin-user  
  namespace: kubernetes-dashboard
---
apiVersion: v1
kind: Secret
metadata:  
  name: admin-user  
  namespace: kubernetes-dashboard  
  annotations:    
    kubernetes.io/service-account.name: "admin-user"
type: kubernetes.io/service-account-token
EOF

kubectl apply -f user.yaml

sleep 5

## getting access token

kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath={".data.token"} | base64 -d

kubectl get svc -A