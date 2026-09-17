# 2주차

Windows에 WSL2로 리눅스 환경을 만들고, Git과 GitHub으로 버전 관리를 시작했다.

## 오늘 배운 내용
- 1. 가상화 (베어메탈/하이퍼바이저/컨테이너)
- 2. WSL2 + Ubuntu 터미널
- 3. 리눅스 기본 명령어 : `ls -l`의 앞 10자리는 1+3+3+3으로 끊어 읽는다. 권한 숫자는 읽기 4, 쓰기 2, 실행 1. `>`는 덮어쓰기, `>>`는 이어 붙이기.
- 4. Git / GitHub 기본

## 새로 배운 명령어

```bash
ls -l / ls -a          # 권한 확인 / 숨김 파일(.git) 확인
chmod 755 file         # 읽기4 쓰기2 실행1
echo "A" >> file       # 이어 붙이기 (>는 덮어쓰기)
sudo !!                # sudo 빼먹었을 때 직전 명령 재실행

git status             # 막히면 일단 이것부터
git add . / git commit -m "메시지"
git log --oneline --all --graph
git switch -c hi       # 브랜치 만들고 이동

gh repo create devops --public --source=. --remote=origin --push
git push
gh auth logout         # 학교 PC는 필수
```




