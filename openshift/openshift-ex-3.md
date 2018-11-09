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
  namespace: student<#>
```
```
$ oc create -f sa.yaml
```

## Create Role
```
$ vi role.yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: student<#>
  name: pod-viewer
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```
```
$ oc create -f role.yaml
```

## Create Role Binding
Give pod view permissions to new sa account-

```
$ vi rolebinding.yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: pod-viewer-binding
  namespace: student<#>
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
$ oc create -f rolebinding.yaml
```

## Get Token for Service Account
We need to token for the newly created service account to use for authentication.

```
$ oc -n student<#> describe secret $(kubectl -n student<#> get secret \
| grep pod-viewer-sa | awk '{print $1}')
Name:         pod-viewer-token-t86v8
Namespace:    student0
Labels:       <none>
Annotations:  kubernetes.io/service-account.name=pod-viewer
              kubernetes.io/service-account.uid=6c503f3a-d51e-11e8-8679-fa163e85a7d2

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
$ oc login --token=<token>
```

## List Pods using new pod-viewer-user
```
$ oc get pods -n student<#>
NAME                                READY     STATUS    RESTARTS   AGE
hello-kubernetes-7fc5bf6466-8gkk5   1/1       Running   0          1h
```

## Delete Pod using new pod-viewer-user
This should fail as the sa only has permissions to view pods.

```
$ oc delete pod hello-kubernetes-7fc5bf6466-8gkk5 -n student<#>
Error from server (Forbidden): pods "hello-kubernetes-7fc5bf6466-8gkk5" is forbidden: User "system:serviceaccount:student0:pod-viewer-sa" cannot delete pods in the namespace "student0": no RBAC policy matched
```

## Delete Pod using student user
```
$ oc login -u student<#>
```
```
$ oc delete pod hello-kubernetes-7fc5bf6466-8gkk5
pod "hello-kubernetes-7fc5bf6466-8gkk5" deleted
```

## View Pods
```
$ oc get pods
NAME                                READY     STATUS    RESTARTS   AGE
hello-kubernetes-7fc5bf6466-v5kcc   1/1       Running   0          7s
```

Note: Pod is recreated since replication controller has a replica count of 1 in deployment config.

