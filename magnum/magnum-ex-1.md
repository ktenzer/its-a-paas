# Exercise 1: Create K8s Configuration on client
You will need to connect to the above system k8s-bastion using your student and password.

## Create Kubernetes Config
```
$ kubectl config set-credentials student0 --namespace=student0 --token=<token>
```

## Set the Kubernetes Cluster
```
$ kubectl config set-cluster k8s --server=https://176.9.171.115:6443 --insecure-skip-tls-verify
```

## Set Context
```
$ kubectl config set-context student0 --user=student0 --cluster=k8s --namespace=student0
```

## Use Context
```
$ kubectl config use-context student0
```

## List Pods in Namespace using Token
```
$ kubectl get pods
```

