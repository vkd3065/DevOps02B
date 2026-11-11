# 10주차 - 쿠버네티스 배포와 서비스

k8s 파일: `guestbook/k8s/deployment.yaml`, `guestbook/k8s/service.yaml`

## 1. replicas 5

```
$ kubectl scale deployment guestbook --replicas=5
$ kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
guestbook-7cf5b85896-8mhp7   1/1     Running   0          18m
guestbook-7cf5b85896-g7dvx   1/1     Running   0          18m
guestbook-7cf5b85896-pq2xm   1/1     Running   0          18m
guestbook-7cf5b85896-xw4nj   1/1     Running   0          17m
guestbook-7cf5b85896-zf8f2   1/1     Running   0          18m
```

## 2. 서비스로 요청 보냈을 때 hostname

```
{"hostname":"guestbook-7cf5b85896-g7dvx","status":"ok"}
{"hostname":"guestbook-7cf5b85896-xw4nj","status":"ok"}
{"hostname":"guestbook-7cf5b85896-zf8f2","status":"ok"}
{"hostname":"guestbook-7cf5b85896-g7dvx","status":"ok"}
{"hostname":"guestbook-7cf5b85896-pq2xm","status":"ok"}
{"hostname":"guestbook-7cf5b85896-zf8f2","status":"ok"}
{"hostname":"guestbook-7cf5b85896-8mhp7","status":"ok"}
```

요청마다 다른 Pod가 응답함.

## 3. Pod 삭제

```
$ kubectl delete pod/guestbook-7cf5b85896-6x24h
guestbook-7cf5b85896-6x24h   1/1     Terminating         0          52s
guestbook-7cf5b85896-xw4nj   0/1     Pending             0          0s
guestbook-7cf5b85896-xw4nj   0/1     ContainerCreating   0          0s
guestbook-7cf5b85896-xw4nj   1/1     Running             0          0s
```

지우자마자 새 Pod가 생김.

## 4. v2 업데이트 후 rollout history

```
$ kubectl set image deployment/guestbook web=ghcr.io/vkd3065/guestbook:v2
$ kubectl rollout history deployment/guestbook
REVISION  CHANGE-CAUSE
1         <none>
2         v2: 제목 변경
```

## 5. 롤백

```
$ kubectl rollout undo deployment/guestbook
$ kubectl get rs
NAME                   DESIRED   CURRENT   READY   AGE
guestbook-5699bdd7b5   0         0         0       5s
guestbook-7cf5b85896   2         2         2       18m
```

예전 ReplicaSet이 다시 2개가 됨.
