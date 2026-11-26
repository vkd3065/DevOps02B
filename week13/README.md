# 13주차 - 깃옵스 (Argo CD)

등록 파일: [`argocd-application.yaml`](../argocd-application.yaml)

Argo CD가 이 저장소 main의 `guestbook/k8s` 폴더를 보고 있다가, 바뀌면 클러스터를 거기에 맞춘다.
prune이랑 selfHeal 둘 다 켰다. 이제 kubectl apply는 안 하고 PR로만 바꾼다.

```
$ kubectl get application -n argocd
NAME        SYNC STATUS   HEALTH STATUS
guestbook   Synced        Healthy
```

## 실습

| | 한 것 | 결과 |
|---|---|---|
| 1 | replicas 2 → 4 PR | Pod 4개 |
| 2 | `kubectl scale --replicas=10` | 바로 4개로 돌아옴 (selfHeal) |
| 3 | `git revert` PR | 다시 2개 |
| 4 | hello ConfigMap 추가 PR → 삭제 PR | 생겼다가 NotFound (prune) |
| 5 | 제목 CI/CD PR → image `1614902` PR | 화면 제목에 CI/CD |

머지한 PR

```
#10 Argo CD Application 기록
#11 replicas 4
#12 Revert "replicas 4 (#11)"
#13 hello ConfigMap 추가
#14 hello ConfigMap 삭제
#15 제목에 CI/CD 변경
#16 배포: 1614902
```

## 모니터링

metrics-server 켜고 `kubectl top`, helm으로 kube-prometheus-stack 설치.
busybox로 계속 요청 보내면서 본 거:

```
$ kubectl top pods
NAME                         CPU(cores)   MEMORY(bytes)   
guestbook-5cc859468f-9ft9h   60m          32Mi            
guestbook-5cc859468f-jm6zz   71m          30Mi            
load                         503m         6Mi             
redis-57d7f66958-4j2jr       18m          7Mi             
```

그라파나는 Kubernetes / Compute Resources / Pod 대시보드.

## 헷갈렸던 거

- 커밋만 하고 push랑 PR을 안 해서 아무리 기다려도 안 바뀌었다. Argo CD는 깃허브 main만 본다.
- 등록하자마자 이미지가 v1로 돌아갔다. 전에 `kubectl set image`로 바꾼 건 Git에 없어서 그렇다.
- 실습 2는 10개로 늘리자마자 되돌아가서 늘어나는 것도 못 봤다.
