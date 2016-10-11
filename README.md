# About :

This project forked from [implydata/distribution-docker](https://github.com/implydata/distribution-docker)

Dockerized version of the distribution in https://github.com/implydata/distribution.

Made for kubernetes imply kafka test

# Usage:

## prerequsite

* Set up git, wget and kubernetes
* Set up coreos-vagrant
** I use vagrant based on virtual box


## On kubernetes

### Run kubernetes zookeeper

#### get yaml file

```
$ wget https://github.com/taeminKwon/kubernetes-zookeeper/archive/v3.4.6.zip
$ unzip v3.4.6.zip
```

#### Run zoo replication controller and service

```
$ cd kubernetes-zookeeper-3.4.6/
$ kubectl create -f zoo-rc.yaml
$ kubectl create -f zoo-service.yaml
```

### Run kubernetes kafka

#### get yaml file

```
$ wget https://github.com/taeminKwon/kubernetes-kafka/archive/v0.9.0.1_tm.zip
$ unzip v0.9.0.1_tm.zip
```

#### Run kafka replication controller and service

```
$ cd kubernetes-kafka-0.9.0.1_tm/
$ kubectl create -f kafka-rc.yaml
$ kubectl create -f kafka-service.yaml
```

### Run kubernetes imply

* Note

** Setup expose ip on imply-dp

```
# kubectl run -i --image=taeminkwon/kubernetes-imply --port=9095 imply-dp

Waiting for pod default/imply-dp-2181728932-9h02x to be running, status is Pending, pod ready: false
Waiting for pod default/imply-dp-2181728932-9h02x to be running, status is Pending, pod ready: false
[Ctrl+C]
```

#### Run imply

##### Check pod

```
$ kubectl get pods
NAME                        READY     STATUS    RESTARTS   AGE
imply-dp-1804961580-dlfny   1/1       Running   0          11m
kafka-broker-jiwxa          1/1       Running   0          14m
kafka-zoo-9118p             1/1       Running   0          17m
```

#### Expose imply

* Note

** Setup external ip for pivot.

```
# kubectl expose deployment imply-dp --target-port=9095 --type=NodePort --external-ip=172.17.4.201
```

#### Start imply service

```
$ kubectl exec imply-dp-1804961580-dlfny -it /bin/bash

root@imply-dp-1804961580-dlfny:~/imply-1.1.0# bin/supervise -c conf/supervise/quickstart.conf
```

### Verify

* Test imply kafka zookeeper test

#### Imput tranquility kafka data

##### Run kafka console producer

Check kafka pods

```
$ kubectl get pods
NAME                        READY     STATUS    RESTARTS   AGE
imply-dp-1804961580-dlfny   1/1       Running   0          11m
kafka-broker-jiwxa          1/1       Running   0          14m
kafka-zoo-9118p             1/1       Running   0          17m
```

Connect to kafka container

```
$ kubectl exec kafka-broker-jiwxa -it /bin/bash
```

Run producer

```
# cd /opt/kafka_2.11-0.9.0.1/
# bin/kafka-console-producer.sh --broker-list kafka:9092 --topic metrics
```

* Do not exit terminal!

##### Generate Sample Data

* Note

** Sample data send to tranquility kafka

Connect to imply container

```
$ kubectl exec imply-dp-1804961580-dlfny -it /bin/bash
# bin/generate-example-metrics
```

##### Input the generated date on kafka-console-producer terminal

##### Check pivot

http://172.17.4.201:9095/pivot


### Remove replication controller on kubernetes [OPTIONS]

#### Check pods

```
$ kubectl get pods
NAME                        READY     STATUS    RESTARTS   AGE
imply-dp-1804961580-dlfny   1/1       Running   0          11m
kafka-broker-jiwxa          1/1       Running   0          14m
kafka-zoo-9118p             1/1       Running   0          17m
```

#### Delete replication controller

```
$ kubectl delete rc kafka-zoo
replicationcontroller "kafka-zoo" deleted

$ kubectl delete rc kafka-broker
replicationcontroller "kafka-broker" deleted
```

#### Delete deployments

```
$ kubectl delete deployment imply-dp
deployment "imply-dp" deleted
```

### Remove service on kubernetes [OPTIONS]

#### Check service

```
$ kubectl get svc
NAME            CLUSTER-IP   EXTERNAL-IP    PORT(S)                      AGE
imply-dp        10.3.0.41    172.17.4.201   9095/TCP                     13m
kafka           10.3.0.40    <none>         9092/TCP                     18m
kafka-zoo-svc   10.3.0.101   <none>         2181/TCP,2888/TCP,3888/TCP   20m
kubernetes      10.3.0.1     <none>         443/TCP                      14d
```

#### Delete service

```
$ kubectl delete svc imply-dp
service "imply-dp" deleted

$ kubectl delete svc kafka
service "kafka" deleted

$ kubectl delete svc kafka-zoo-svc
service "kafka-zoo-svc" deleted
```
