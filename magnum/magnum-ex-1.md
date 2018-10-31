# Exercise 1: Create K8s Configuration on client
You will need to connect to the above system k8s-bastion using your student and password.

## Create Kubernetes Config
```$ kubectl config set-credentials student1 --server=https://176.9.171.119:6443 \
--insecure-skip-tls-verify --namespace=student1 --token=<token>```
## Set the Kubernetes Cluster
```$ kubectl config set-cluster k8s-test --server=https://176.9.171.119:6443 \
--insecure-skip-tls-verify```

## List Pods in Namespace using Token
```$ kubectl get pods```

