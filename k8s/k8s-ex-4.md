## Exercise 4: Clean-up

In this exercise we will clean up our namespace & remove now-unneeded
ServiceAccounts & permissions.


## Delete Hello Kubernetes app

````
$ kubectl delete all -l app=hello-kubernetes
deployment "hello-kubernetes" deleted
````

## Delete Service
```
$ kubectl get services
NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
hello-kubernetes         NodeIP   172.30.89.88    <none>        80/TCP    1h
```

```
$ kubectl delete service hello-kubernetes
service "hello-kubernetes" deleted
```

## Delete Secrets

First, list secrets belonging to `pod-viewer-xxxxx`

````
$ kubectl get secrets
````
````
default-token-hbl9x         kubernetes.io/service-account-token   3         3d
pod-viewer-sa-token-drqvv   kubernetes.io/service-account-token   3         19m
student$N-token-jdhwh        kubernetes.io/service-account-token   3         3d
````

Delete the secret

````
$ kubectl delete secret pod-viewer-sa-token-drqvv 
secret "pod-viewer-sa-token-drqvv" deleted
````
## Delete RoleBindings

List all RoleBindings in your namespace:

````
$ kubectl get rolebindings
NAME                 AGE
admin                3d
pod-viewer-binding   17m
````

Delete the `pod-viewer-binding` RoleBinding

````
$ kubectl delete rolebinding pod-viewer-binding
rolebinding.rbac.authorization.k8s.io "pod-viewer-binding" deleted
````

## Delete Roles
List roles in your namespace:

````
$ kubectl get roles
NAME         AGE
pod-viewer   18m
````

Delete the `pod-viewer` role

````
$ kubectl delete role pod-viewer
role.rbac.authorization.k8s.io "pod-viewer" deleted
````

## Delete ServiceAccounts

List ServiceAccounts in your namespace

````
$ kubectl get sa
NAME            SECRETS   AGE
default         1         3d
pod-viewer-sa   1         20m
student0        1         3d
````

Delete the `pod-viewer-sa` ServiceAccount

````
$ kubectl delete sa pod-viewer-sa
serviceaccount "pod-viewer-sa" deleted
````

## Verification

Verify that the `pod-viewer` ServiceAccount has been removed by attempting to
list pods.

````
$ kubectl get pods --user=pod-viewer
error: You must be logged in to the server (Unauthorized)
````
