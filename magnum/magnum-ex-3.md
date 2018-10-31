# Exercise 3: Create an RBAC User to list pods
K8s can use authentication like LDAP or even Keystone. In this case though we will use service accounts and tokens to show how to provide RBAC without an authentication layer.

You will create a new service account called pod-viewer that has permission to view pods in your student namespace.

## Create Service Account
Create new pod-viewer sa.

```
$ vi sa.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: student1
  namespace: student1
Create Role in Namespace
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: student1
  name: pod-viewer
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```
 ```
$ kubectl create -f sa.yaml
```

## Create Role Binding
Give pod view permissions to new sa account-

```
$ vi rolebinding.yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: pod-viewer-binding
  namespace: student1
subjects:
- kind: ServiceAccount
  name: pod-viewer-user
  apiGroup: ""
roleRef:
  kind: Role
  name: pod-viewer
  apiGroup: ""
```

## Get Token for Service Account
We need to token for the newly created service account so we can add it to our local kubectl configuration.

```
[student1@k8s-bastion ~]$ kubectl -n student1 describe secret $(kubectl -n student1 get secret \
| grep pod-viewer-user | awk '{print $1}')
Name:         pod-viewer-token-t86v8
Namespace:    student1
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
$ kubectl config set-credentials pod-viewer --server=https://176.9.171.119:6443 \ --insecure-skip-tls-verify --namespace=student1 --token=eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJzdHVkZW50MSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJwb2Qtdmlld2VyLXRva2VuLXQ4NnY4Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6InBvZC12aWV3ZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI2YzUwM2YzYS1kNTFlLTExZTgtODY3OS1mYTE2M2U4NWE3ZDIiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6c3R1ZGVudDE6cG9kLXZpZXdlciJ9.iX66PdH0ZciYRoiZg9KsYHe6cszyF4mOVihVsML9OlGR6DnbMx2ooNJLpNdsfG6ssy2orHd3kxSuHs0s54ve1-zuC8LvQ7UoQ_NTi0rnyM6WX6mlZa7Ytfq8fraNFT4Fw_XHP-K0YgX5O9cIbi0-z_wBI1mBqzCHMJzDP4qjjFgzfa6ml4jUPTPcNlGMfYsjoBWRumyDQcfXh4DjKUq53QbLBSPLrpnUx2hZ1PoJ_QAHdXcDbnOlToKefIP_VAeRHwe2vxWoT3ywu6kTovOn4yfsII_xWMJRc5MAdRnW1SzsdctHE-mZdyBoWZb1vLbW8L9Xzy7vhShXwPqT8CYC7g
```

## List Pods using new pod-viewer-user
```
[student1@k8s-bastion ~]$ kubectl get pods --user=pod-viewer
NAME READY STATUS RESTARTS AGE
hello-kubernetes-7fc5bf6466-kkp22 1/1 Running 0 28m
```

## Delete Pod using new pod-viewer-user
This should fail as the sa only has permissions to view pods-

```
[student1@k8s-bastion ~]$ kubectl delete pod hello-kubernetes-7fc5bf6466-kkp22 --user=pod-viewer
Error from server (Forbidden): pods "hello-kubernetes-7fc5bf6466-kkp22" is forbidden: User "system:serviceaccount:student1:pod-viewer" cannot delete pods in the namespace "student1"
```

## Delete Pod using student1 user
This should work as the student sa has admin permissions to namespace.
```
[student1@k8s-bastion ~]$ kubectl delete pod hello-kubernetes-7fc5bf6466-kkp22 --user=student1
pod "hello-kubernetes-7fc5bf6466-kkp22" deleted
View Pods again using pod-viewer-user
```
```
[student1@k8s-bastion ~]$ kubectl get pods --user=pod-viewer
NAME READY STATUS RESTARTS AGE
hello-kubernetes-7fc5bf6466-hq7dh 1/1 Running 0 46s
```

Note: Pod is recreated since replication controller has a replica count of 1 in deployment config.

