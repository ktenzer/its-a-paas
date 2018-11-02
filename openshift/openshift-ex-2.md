# Exercise 2: Create Hello World Application and Service
Note: For this demo we will use Paul Bouwer's hello world app.

## Create Service and Deployment Config

```
$ vi kubernetes-hello.yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-kubernetes
spec:
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: hello-kubernetes
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-kubernetes
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-kubernetes
  template:
    metadata:
      labels:
        app: hello-kubernetes
    spec:
      containers:
      - name: hello-kubernetes
        image: paulbouwer/hello-kubernetes:1.5
        ports:
        - containerPort: 8080
        env:
        - name: MESSAGE
          value: Hello World on Kubernetes!
```

## Deploy App and Service
```
oc create -f kubernetes-hello.yml
```

## Check the pods
```
$ oc get pods -o wide
NAME                                READY     STATUS    RESTARTS   AGE       IP          NODE      NOMINATED NODE
hello-kubernetes-7fc5bf6466-8gkk5   1/1       Running   0          5m        10.30.4.2   node3     <none>
```

## Check the service
```
$ oc get service
NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
hello-kubernetes   ClusterIP   172.30.33.172   <none>        80/TCP    1m
```

## Create route (expose service externally)
By default all services can only communicate internally. Exposing them and thus creating a route will add an entry to the OpenShift router (running on infra nodes). It is basically an ha-proxy and will load balance as well as route incoming traffic to correct service based on the incomming URL.

```
$ oc expose serve hello-kubernetes
```

## Check routes
You will notice the route is the service + project and the wildcard domain. In this case we are using xip.io, this is just a reverse proxy. It will send anything at 5.9.163.226.xip.io to ip 5.9.163.226. This is of course the IP of our infra load balancer running in OpenStack. It is balancing traffic across the two OpenShift routers which explained above are ha-proxy containers.

A light should have went on by now and you should be thinking, wow OpenShift is freaking awesome. This is just the beginning!
```
$ oc get routes
NAME               HOST/PORT                                           PATH      SERVICES           PORT      TERMINATION   WILDCARD
hello-kubernetes   hello-kubernetes-student0.apps.5.9.163.226.xip.io             hello-kubernetes   8080                    None
```
## Connect to application using the route (url)

http://hello-kubernetes-student0.apps.5.9.163.226.xip.io

## Check out the project in the OpenShift UI
https://openshift.5.9.163.229.xip.io:8443

![](images/hello-kubernetes.okd.PNG)
