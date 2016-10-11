# About :

This project forked from [implydata/distribution-docker](https://github.com/implydata/distribution-docker)

Dockerized version of the distribution in https://github.com/implydata/distribution.

Made for kubernetes imply kafka test

# Usage:

## prerequsite

* Setup git, kubernetes

## On kubernetes

### Run kubernetes zookeeper

#### get yaml file

```
# git clone https://github.com/taeminKwon/kubernetes-zookeeper/releases/tag/v3.4.6
```

#### Run zoo replication controller and service

```
# cd kubernetes-zookeeper
# kubectl create -f zoo-rc.yaml
# kubectl create -f zoo-service.yaml
```

### Run kubernetes kafka

#### get yaml file

```
# git clone https://github.com/taeminKwon/kubernetes-kafka/releases/tag/v0.9.0.1_tm
```

#### Run kafka replication controller and service

```
# cd kubernetes-kafka
# kubectl create -f kafka-rc.yaml
# kubectl create -f kafka-service.yaml
```

### Run kubernetes imply

* Note
** Container 실행 및 외부 IP 로 expose 실행

```
# kubectl run -i --image=taeminkwon/kubernetes-imply:1.1.0 --port=9095 imply-dp

Ctrl+C
```

#### Run imply

##### Check pod

```
$ kubectl get pods
NAME                        READY     STATUS    RESTARTS   AGE
imply-dp-1942981254-46vjn   1/1       Running   0          31s
```

#### Expose imply

* Note
** Setup external ip for pivot.

```
# kubectl expose deployment imply-dp --target-port=9095 --type=NodePort --external-ip=172.17.4.201
```

#### Start imply service

```
$ kubectl exec imply-dp-1942981254-46vjn -it /bin/bash

root@imply-dp-1942981254-46vjn:~/imply-1.1.0# bin/supervise -c conf/supervise/quickstart.conf
```

### Verify

* Test imply kafka zookeeper test

#### Imput tranquility kafka data

##### Run kafka console producer

Check kafka pods

```
$ kubectl get pods
NAME                        READY     STATUS    RESTARTS   AGE
imply-dp-1942981254-gs37x   1/1       Running   0          16h
kafka-broker-voibg          1/1       Running   0          3m
kafka-zoo-iyj1v             1/1       Running   0          37m
```

Connect to kafka container

```
$ kubectl exec kafka-broker-voibg -it /bin/bash
```

Run producer

```
# cd /opt/kafka_2.11-0.9.0.1/
# bin/kafka-console-producer.sh --broker-list kafka:9092 --topic metrics
```

* producer 창을 그대로 둔 후 다른 터미널 Open

##### Generate Sample Data

* Note
** tranquility kafka 에 사용할 Sample Data 전송

Connect to imply container

```
$ kubectl exec imply-dp-1942981254-gs37x -it /bin/bash
# bin/generate-example-metrics
```

##### Input the generated date on kafka-console-producer terminal

##### Check pivot

http://172.17.4.201:9095/pivot
