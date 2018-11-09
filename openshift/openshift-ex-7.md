## Exercise 7: Clean-up

In this exercise we will clean up our namespace & remove now-unneeded
ServiceAccounts & permissions.


## Delete Hello Kubernetes app

````
$ oc delete all -l app=hello-kubernetes
pod "hello-kubernetes-d4b87557b-x5qlj" deleted
replicaset.apps "hello-kubernetes-7fc5bf6466" deleted
replicaset.apps "hello-kubernetes-d4b87557b" deleted
````

```
$ oc delete all -l app=hello-openstack-summit
pod "hello-openstack-summit-54455d5d98-77b78" deleted
pod "hello-openstack-summit-54455d5d98-9fr55" deleted
pod "hello-openstack-summit-54455d5d98-wfzxd" deleted
replicaset.apps "hello-openstack-summit-54455d5d98" deleted
```

## Delete Services
```
$ oc get services
NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
hello-kubernetes         ClusterIP   172.30.89.88    <none>        80/TCP    1h
hello-openstack-summit   ClusterIP   172.30.66.131   <none>        80/TCP    1h
```

```
$ oc delete service hello-kubernetes
service "hello-kubernetes" deleted
```

```
$ oc delete service hello-openstack-summit
service "hello-openstack-summit" deleted
```

## Delete Secrets

First, list secrets belonging to `pod-viewer-xxxxx`

````
$ oc get secrets
````
````
NAME                            TYPE                                  DATA      AGE
builder-dockercfg-qtjtd         kubernetes.io/dockercfg               1         1h
builder-token-4lqmw             kubernetes.io/service-account-token   4         1h
builder-token-pxmrv             kubernetes.io/service-account-token   4         1h
default-dockercfg-466cp         kubernetes.io/dockercfg               1         1h
default-token-fwkwn             kubernetes.io/service-account-token   4         1h
default-token-jmctx             kubernetes.io/service-account-token   4         1h
deployer-dockercfg-8z6bp        kubernetes.io/dockercfg               1         1h
deployer-token-g4cnq            kubernetes.io/service-account-token   4         1h
deployer-token-g8q4z            kubernetes.io/service-account-token   4         1h
pod-viewer-sa-dockercfg-tcz5p   kubernetes.io/dockercfg               1         1h
pod-viewer-sa-token-29b5l       kubernetes.io/service-account-token   4         1h
pod-viewer-sa-token-dd4lx       kubernetes.io/service-account-token   4         1h
````

Delete the secret

````
$ oc delete secret pod-viewer-sa-token-29b5l
secret "pod-viewer-sa-token-29b5l" deleted
````
## Delete RoleBindings

List all RoleBindings in your namespace:

````
$ oc get rolebindings
NAME                    ROLE                    USERS      GROUPS                            SERVICE ACCOUNTS   SUBJECTS
admin                   /admin                  student0                                            
pod-viewer-binding      student0/pod-viewer                                                  pod-viewer-sa
system:deployers        /system:deployer                                                     deployer
system:image-builders   /system:image-builder                                                builder
system:image-pullers    /system:image-puller               system:serviceaccounts:student0          
[student0@bastion ~]$ oc get rolebindings
NAME                    ROLE                    USERS      GROUPS                            SERVICE
admin                   /admin                  student0
pod-viewer-binding      student0/pod-viewer                                                  pod-vie
system:deployers        /system:deployer                                                     deploye
system:image-builders   /system:image-builder                                                builder
system:image-pullers    /system:image-puller               system:serviceaccounts:student0
````

Delete the `pod-viewer-binding` RoleBinding

````
$ oc delete rolebinding pod-viewer-binding
rolebinding.rbac.authorization.k8s.io "pod-viewer-binding" deleted
````

## Delete Roles
List roles in your namespace:

````
$ oc get roles
NAME         AGE
pod-viewer   18m
````

Delete the `pod-viewer` role

````
$ oc delete role pod-viewer
role.rbac.authorization.k8s.io "pod-viewer" deleted
````

## Delete ServiceAccounts

List ServiceAccounts in your namespace

````
$ oc get sa
NAME            SECRETS   AGE
builder         2         1h
default         2         1h
deployer        2         1h
pod-viewer-sa   2         1h
````

Delete the `pod-viewer-sa` ServiceAccount

````
$ oc delete sa pod-viewer-sa
serviceaccount "pod-viewer-sa" deleted
````

## Verification

Verify that the `pod-viewer` ServiceAccount has been removed by attempting to
list pods.

````
$ oc get pods --user=pod-viewer
error: You must be logged in to the server (Unauthorized)
````
