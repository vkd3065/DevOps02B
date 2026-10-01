# 5주차 - Docker

Docker Desktop을 설치하고 nginx 컨테이너를 실행했다.
이슈 → 브랜치 → PR → Merge 흐름으로 기록했다.


## 실행 환경
- `docker --version` → docker-version.txt
- `docker info` → docker-info.txt

## 실행 결과
- `docker run hello-world` → docker-run-hello-world.txt
- `docker run -d -p 8080:80 --name web nginx`
- `curl -I http://localhost:8080` → curl-result.txt
- `docker ps` → docker-ps.txt

## 배운 내용
- 이미지(붕어빵 틀) → docker run → 컨테이너(붕어빵)
- -p 호스트포트:컨테이너포트, -d 백그라운드, -e 환경 변수
- 컨테이너를 지우면 안에서 바꾼 내용(쓰기 계층)도 사라진다
- 파이썬 3.9 / 3.12를 설치 없이 비교했다 (match-case)


## 혼자서 해보기 - curl 결과
```
<h1>Welcome to nginx1</h1>
<h1>Welcome to nginx2</h1>
<h1>Welcome to nginx3</h1>
```
