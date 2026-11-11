# 10주차 - 쿠버네티스 배포와 서비스

작성한 파일: [guestbook/k8s/deployment.yaml](../guestbook/k8s/deployment.yaml), [guestbook/k8s/service.yaml](../guestbook/k8s/service.yaml)

## 1. replicas 5

`kubectl scale deployment guestbook --replicas=5` 후 `kubectl get pods`

```
NAME                         READY   STATUS    RESTARTS   AGE
guestbook-7cf5b85896-8mhp7   1/1     Running   0          18m
guestbook-7cf5b85896-g7dvx   1/1     Running   0          18m
guestbook-7cf5b85896-pq2xm   1/1     Running   0          18m
guestbook-7cf5b85896-xw4nj   1/1     Running   0          17m
guestbook-7cf5b85896-zf8f2   1/1     Running   0          18m
```

## 2. 서비스를 통과한 요청의 Pod hostname

lb-check(busybox)로 `http://guestbook/healthz`에 10번 요청

```
{"hostname":"guestbook-7cf5b85896-g7dvx","status":"ok"}
{"hostname":"guestbook-7cf5b85896-xw4nj","status":"ok"}
{"hostname":"guestbook-7cf5b85896-zf8f2","status":"ok"}
{"hostname":"guestbook-7cf5b85896-g7dvx","status":"ok"}
{"hostname":"guestbook-7cf5b85896-pq2xm","status":"ok"}
{"hostname":"guestbook-7cf5b85896-zf8f2","status":"ok"}
{"hostname":"guestbook-7cf5b85896-8mhp7","status":"ok"}
{"hostname":"guestbook-7cf5b85896-zf8f2","status":"ok"}
{"hostname":"guestbook-7cf5b85896-xw4nj","status":"ok"}
{"hostname":"guestbook-7cf5b85896-pq2xm","status":"ok"}
```

같은 주소로 보냈는데 5개 Pod가 골고루 응답했다. 서비스가 요청을 나눠 준다.

## 3. Pod 강제 삭제 → 자동으로 다시 생김

`kubectl get pods -w`를 켜 두고 `kubectl delete pod/guestbook-7cf5b85896-6x24h`

```
guestbook-7cf5b85896-6x24h   1/1     Terminating         0          52s
guestbook-7cf5b85896-xw4nj   0/1     Pending             0          0s
guestbook-7cf5b85896-xw4nj   0/1     ContainerCreating   0          0s
guestbook-7cf5b85896-xw4nj   1/1     Running             0          0s
```

지운 Pod 대신 새 이름(xw4nj)의 Pod가 바로 생겼다. ReplicaSet이 개수를 맞춘다.

## 4. v1 → v2 롤링 업데이트 후 rollout history

제목에 v2를 붙여 이미지를 만들고 `kubectl set image deployment/guestbook web=ghcr.io/vkd3065/guestbook:v2`

```
$ kubectl get rs
NAME                   DESIRED   CURRENT   READY   AGE
guestbook-5699bdd7b5   2         2         2       2s
guestbook-7cf5b85896   0         0         0       18m

$ kubectl rollout history deployment/guestbook
REVISION  CHANGE-CAUSE
1         <none>
2         v2: 제목 변경
```

## 5. 롤백

`kubectl rollout undo deployment/guestbook`

```
$ kubectl get rs
NAME                   DESIRED   CURRENT   READY   AGE
guestbook-5699bdd7b5   0         0         0       5s
guestbook-7cf5b85896   2         2         2       18m

$ kubectl rollout history deployment/guestbook
REVISION  CHANGE-CAUSE
2         v2: 제목 변경
3         v1: 롤백
```

옛 ReplicaSet(7cf5b85896)이 다시 2개가 되고 v2 쪽은 0이 됐다. 롤백하면 1번이 3번으로 다시 올라온다.

## 막혔던 것

- 처음 lb-check를 돌렸을 때 `wget: bad address 'guestbook'`이 몇 번 나왔다. 서비스를 막 만든 직후라 그런 것 같고, 잠깐 기다렸다가 다시 하니 정상으로 나왔다.
