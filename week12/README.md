# 12주차 - 깃허브 액션

워크플로: `.github/workflows/build.yml` / 테스트: `guestbook/tests/test_app.py`

## 1. 첫 워크플로

브랜치에서 작업 → PR → 머지. PR에서는 검사랑 빌드만 하고, main에 머지되면 이미지를 ghcr.io에 올린다.

```
$ gh run list
completed  success  깨진 코드로 PR  Build and Push Image  feature/broken-test
completed  failure  깨진 코드로 PR  Build and Push Image  feature/broken-test
completed  success  오타 실험  Build and Push Image  feature/ci-errors-2
completed  failure  오타 실험  Build and Push Image  feature/ci-errors-2
completed  failure  오타 실험  Build and Push Image  feature/ci-errors-2
completed  success  문법 오류 확인  Build and Push Image  feature/ci-errors
completed  failure  문법 오류 확인  Build and Push Image  feature/ci-errors
completed  success  CI 파이프라인 추가 (#5)  Build and Push Image  main
completed  success  CI 파이프라인 추가  Build and Push Image  feature/ci-setup
```

이미지: `ghcr.io/vkd3065/guestbook:0eb4eb8` (커밋 해시 태그)
`kubectl set image`로 바꾸니 화면 제목 끝에 new가 붙었다. docker build, push는 직접 안 했다.

## 2. 빨간X → 초록✓

| 실험 | 멈춘 단계 | 로그 |
|---|---|---|
| `def broken(:` | 코드 검사 (Lint) | invalid-syntax |
| `print(APP_TITL)` | 코드 검사 (Lint) | F821 Undefined name |
| healthz 200 → 500 | 앱 동작 테스트 | AssertionError: 500 != 200 |

오타는 compileall로는 통과(0)했는데 린트가 잡았다. 500은 린트는 통과하고 테스트가 잡았다.
앞 단계가 실패하면 빌드 & 푸시까지 안 가서 이미지가 안 만들어진다.

## 3. main 브랜치 보호

룰세트로 PR 필수 + build 검사 통과 필수.

```
$ git push
 ! [remote rejected] main -> main (push declined due to repository rule violations)
```

깨진 코드로 PR을 열면 머지 상태가 BLOCKED로 막혔고, 고쳐서 초록✓가 된 뒤에 머지됐다.
