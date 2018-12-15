# Exercise 3: Create an Service Account to list pods
In this exercise we will create a service account and setup RBAC to allow a service account to view pods in our project.

You will create a new service account called pod-viewer that has permission to view pods in your student namespace.

## Create Service Account
Create new pod-viewer sa.

```
$ vi sa.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pod-viewer-sa
  namespace: student$N  # Change `student$N` to your current namespace
```
```
$ kubectl create -f sa.yaml
```

## Create Role
```
$ vi role.yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: student$N  # Change to your current namespace
  name: pod-viewer
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```
```
$ kubectl create -f role.yaml
```

## Create Role Binding
Give pod view permissions to new sa account-

```
$ vi rolebinding.yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: pod-viewer-binding
  namespace: student$N  # Change this to your namespace
subjects:
- kind: ServiceAccount
  name: pod-viewer-sa
  apiGroup: ""
roleRef:
  kind: Role
  name: pod-viewer
  apiGroup: ""
```
```
$ kubectl create -f rolebinding.yaml
```

## Get Token for Service Account
We need to token for the newly created service account to use for authentication.

```
$ kubectl -n student$N describe secret $(kubectl -n student$N get secret \
| grep pod-viewer-user | awk '{print $1}')
Name:         pod-viewer-token-xxxxx
Namespace:    student$N
Labels:       <none>
Annotations:  kubernetes.io/service-account.name=pod-viewer
              kubernetes.io/service-account.uid=00000000-0000-0000-0000-000000000000

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1046 bytes
namespace:  8 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJzdHVkZW50MSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJwb2Qtdmlld2VyLXRva2VuLXQ4NnY4Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6InBvZC12aWV3ZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI2YzUwM2YzYS1kNTFlLTExZTgtODY3OS1mYTE2M2U4NWE3ZDIiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6c3R1ZGVudDE6cG9kLXZpZXdlciJ9.iX66PdH0ZciYRoiZg9KsYHe6cszyF4mOVihVsML9OlGR6DnbMx2ooNJLpNdsfG6ssy2orHd3kxSuHs0s54ve1-zuC8LvQ7UoQ_NTi0rnyM6WX6mlZa7Ytfq8fraNFT4Fw_XHP-K0YgX5O9cIbi0-z_wBI1mBqzCHMJzDP4qjjFgzfa6ml4jUPTPcNlGMfYsjoBWRumyDQcfXh4DjKUq53QbLBSPLrpnUx2hZ1PoJ_QAHdXcDbnOlToKefIP_VAeRHwe2vxWoT3ywu6kTovOn4yfsII_xWMJRc5MAdRnW1SzsdctHE-mZdyBoWZb1vLbW8L9Xzy7vhShXwPqT8CYC7g
```

## Create local config for new user
Using the token above create a new set of local credentials for our pod-viewer sa.

```
$ kubectl config set-credentials pod-viewer --server=https://192.168.3.107:6443 \
    --insecure-skip-tls-verify --namespace=student$N \
    --token=eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJzdHVkZW50MSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJwb2Qtdmlld2VyLXRva2VuLXQ4NnY4Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6InBvZC12aWV3ZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI2YzUwM2YzYS1kNTFlLTExZTgtODY3OS1mYTE2M2U4NWE3ZDIiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6c3R1ZGVudDE6cG9kLXZpZXdlciJ9.iX66PdH0ZciYRoiZg9KsYHe6cszyF4mOVihVsML9OlGR6DnbMx2ooNJLpNdsfG6ssy2orHd3kxSuHs0s54ve1-zuC8LvQ7UoQ_NTi0rnyM6WX6mlZa7Ytfq8fraNFT4Fw_XHP-K0YgX5O9cIbi0-z_wBI1mBqzCHMJzDP4qjjFgzfa6ml4jUPTPcNlGMfYsjoBWRumyDQcfXh4DjKUq53QbLBSPLrpnUx2hZ1PoJ_QAHdXcDbnOlToKefIP_VAeRHwe2vxWoT3ywu6kTovOn4yfsII_xWMJRc5MAdRnW1SzsdctHE-mZdyBoWZb1vLbW8L9Xzy7vhShXwPqT8CYC7g
```

## List Pods using new pod-viewer-user
```
$ kubectl get pods --user=pod-viewer
NAME READY STATUS RESTARTS AGE
hello-kubernetes-7fc5bf6466-kkp22 1/1 Running 0 28m
```

## Delete Pod using new pod-viewer-user
This should fail as the sa only has permissions to view pods.

```
$ kubectl delete pod hello-kubernetes-7fc5bf6466-kkp22 --user=pod-viewer
Error from server (Forbidden): pods "hello-kubernetes-7fc5bf6466-kkp22" is forbidden: User "system:serviceaccount:student1:pod-viewer" cannot delete pods in the namespace "student1"
```

## Delete Pod using student1 user
```
$ kubectl delete pod hello-kubernetes-7fc5bf6466-kkp22 --user=student$N
pod "hello-kubernetes-7fc5bf6466-kkp22" deleted
View Pods again using pod-viewer-user
```
```
$ kubectl get pods --user=pod-viewer
NAME READY STATUS RESTARTS AGE
hello-kubernetes-7fc5bf6466-hq7dh 1/1 Running 0 46s
```

Note: Pod is recreated since replication controller has a replica count of 1 in deployment config.

