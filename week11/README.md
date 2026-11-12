# 11주차 - 쿠버네티스 설정과 상태 점검

k8s 파일: `guestbook/k8s/configmap.yaml`, `redis.yaml`, `deployment.yaml` (secret.yaml은 올리지 않고 `secret.yaml.example`만 올림)

## 1. Secret 까보기

```
$ kubectl get secret guestbook-secret -o jsonpath='{.data.REDIS_PASSWORD}' | base64 -d; echo
devops1234
```

Secret 값은 암호화가 아니라 base64로 바꿔 적은 것뿐이라 `base64 -d` 한 번이면 원래 비밀번호가 나온다.
`-o yaml`로 보면 last-applied-configuration 메모에 `"REDIS_PASSWORD":"devops1234"`가 그대로 남아 있었다.

## 2. ConfigMap만 바꿔서 제목, 색 변경

```
$ kubectl edit configmap guestbook-config
configmap/guestbook-config edited
$ kubectl get configmap guestbook-config -o jsonpath='{.data}'; echo
{"APP_TITLE":"New 방명록 (k8s)","REDIS_HOST":"redis","REDIS_PORT":"6379","THEME_COLOR":"#e11d48"}
$ kubectl rollout restart deployment guestbook
$ kubectl exec deploy/guestbook -- printenv APP_TITLE THEME_COLOR
New 방명록 (k8s)
#e11d48
```

| | 제목 | 색 |
|---|---|---|
| 바꾸기 전 | 방명록 (k8s) | #16a34a |
| edit 직후 (restart 전) | 방명록 (k8s) | #16a34a |
| restart 후 | New 방명록 (k8s) | #e11d48 |

edit만 하고 restart 안 하면 그대로였다. 이미지는 다시 안 만들었고 저장소는 계속 Redis.

## 3. 헬스체크 실패

### readiness - redis를 0개로

```
$ kubectl scale deployment redis --replicas=0
$ kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
guestbook-75f9f7d4d9-jqk59   0/1     Running   0          39s
guestbook-75f9f7d4d9-n9hqr   0/1     Running   0          45s
```

Running인데 READY가 0/1. /readyz가 503을 주고 서비스로 접속하면 `Connection refused`. 재시작은 안 됐고 redis를 1로 돌리니 다시 1/1이 됐다.

### liveness - 경로를 /devops로

```
$ kubectl get pods -l app=guestbook
NAME                         READY   STATUS    RESTARTS      AGE
guestbook-5bc4d4cc97-9qmz9   1/1     Running   1 (36s ago)   78s
guestbook-5bc4d4cc97-wcvtj   1/1     Running   1 (41s ago)   83s

Warning  Unhealthy  20s (x4 over 73s)  kubelet  ... Liveness probe failed: HTTP probe failed with statuscode: 404
Normal   Killing    20s (x2 over 68s)  kubelet  ... Container web failed liveness probe, will be restarted
```

없는 주소라 404 → 앱은 멀쩡한데 계속 재시작됨. `kubectl apply -f k8s/deployment.yaml`로 원래대로 돌렸다.

## 4. 트러블슈팅 3단 루틴

1. `kubectl get pods` - 뭐가 이상한지 본다 (STATUS, READY, RESTARTS)
2. `kubectl describe pod 이름` - 맨 아래 Events에서 왜 그런지 본다
3. `kubectl logs 이름` - 앱이 남긴 에러를 본다. 계속 죽으면 `--previous`
