
# 4주차 - 자동화와 협업 · 네트워크

셸 스크립트로 백업을 자동화하고, 브랜치 → PR → Merge 흐름과 충돌 해결을 해봤다.
네트워크 기본(IP · 포트 · DNS)도 명령어로 확인했다.

## 배운 내용

자동화 — `find`는 이름으로, `grep`은 내용으로 찾는다. `|`는 앞 명령의 출력을 뒤 명령의 입력으로 넘긴다.

백업 — `tar -czf`로 묶고, 다른 폴더에 풀어 `diff -rq`로 원본과 비교했다. 종료 상태가 0이면 같다. 백업 결과물은 `.gitignore`로 Git에서 뺐다.

프로세스 — 프로그램은 디스크의 파일, 프로세스는 실행 중인 것. `ps aux`로 PID를 찾고 `kill`로 끈다. `kill -9`는 최후의 수단.

협업— main을 직접 고치지 않고 브랜치에서 작업 → push → PR → Merge. 같은 줄을 서로 다르게 고치면 충돌이 나고, `<<<<<<<` `=======` `>>>>>>>` 표시를 정리해서 해결한다.

네트워크 — IP는 건물 주소, 포트는 호수. DNS는 이름을 IP로 바꾼다. 같은 포트로 서버를 두 번 띄우면 `Address already in use`.

## 과제

- PR #1 백업 로그 기록 기능 추가 — https://github.com/vkd3065/DevOps02B/pull/1
- PR #2 충돌 발생 후 해결 (보너스) — https://github.com/vkd3065/DevOps02B/pull/2

## 새로 배운 명령어

```bash
grep -n "ERROR" server.log            # 내용으로 찾기 (줄 번호)
find . -name "*.sh"                   # 이름으로 찾기
tar -czf 묶음.tar.gz 폴더              # 묶기
tar -xzf 묶음.tar.gz -C 풀곳           # 다른 곳에 풀기
diff -rq A B                          # 다른지만 비교
ps aux | grep 이름                    # PID 찾기
git switch -c feature/이름             # 브랜치 만들고 이동
gh pr create --title "제목" --body "설명" --base main
git fetch origin && git merge origin/main   # 충돌을 내 쪽에서 해결
ss -tlnp | grep 8080                  # 포트를 누가 쓰는지
python3 -m http.server 8080           # 간단한 웹 서버
```
