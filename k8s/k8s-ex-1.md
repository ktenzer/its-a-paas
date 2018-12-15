# Exercise 1: Create K8s Configuration on client
You will need to connect to the above system k8s-bastion using your student and password.

## Create Kubernetes Config
```
$ kubectl config set-credentials student$N --namespace=student<#> --token=<token>
```

## Set the Kubernetes Cluster
```
$ kubectl config set-cluster k8s --server=https://<master api ip address>:6443 --insecure-skip-tls-verify
```

## Set Context
```
$ kubectl config set-context student$N --user=student<#> --cluster=k8s --namespace=student0
```

## Use Context
```
$ kubectl config use-context student<#>
```

## List Pods in Namespace using Token
```
$ kubectl get pods
No resources found.
```

Getting no resources found is expected because we don't have any running pods yet.

