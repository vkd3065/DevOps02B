# 3주차 

Ollama로 로컬 AI를 띄우고, 실행 절차를 셸 스크립트로 자동화했다.

## 오늘 배운 내용
- 1. 자동화의 필요성 (10분 × 365일 = 약 61시간, 사람은 반드시 실수한다)
- 2. Qwen + Ollama : 브라우저(:8000) → chat.py → Ollama(:11434) → 모델. 셋 다 켜져 있어야 동작
- 3. 셸 스크립트 : `#!/bin/bash`(셔뱅)가 어떤 프로그램으로 해석할지 정한다. 새 파일엔 실행 권한이 없어서 `chmod u+x`가 항상 따라온다. `exec`는 현재 셸을 대체해 프로세스를 하나 줄인다.
- 4. 경로 처리 : `$0`은 스크립트 자신, `dirname`은 폴더 부분, `$( )`는 명령 결과를 자리에 끼워넣는 치환. 덕분에 어디서 실행해도 같은 결과가 나온다.
- 5. 종료 상태 : 0이 성공, 0이 아니면 실패. 다른 언어와 반대다. `||`는 앞이 실패했을 때만 뒤를 실행한다.
- 6. 환경 변수 : `export`로 코드를 안 고치고 설정을 바꾼다. 스크립트 안의 export는 원래 터미널에 영향을 주지 않는다.
- 7. 표준 출력/오류 : 1번은 결과, 2번은 오류. `>/dev/null 2>&1`은 둘 다 버리기, `>&2`는 오류로 내보내기.

## 만든 것
- `start.sh` — 대화방 실행 + python3 설치 검사
- `start_with_export.sh` — 모델을 환경 변수로 지정
- `start_with_export_2.sh` — 포트를 8080으로 변경

## 새로 배운 명령어

```bash
ollama pull qwen3:0.6b    # 모델 다운로드 (콜론 뒤 크기까지 필수)
ollama list               # 받은 모델 확인
export MODEL="qwen3:0.6b" # 코드 수정 없이 설정 전달

chmod u+x start.sh        # 새 파일엔 실행 권한이 없다
./start.sh                # ./ 를 빼면 command not found

cat > file.sh << 'EOF'    # heredoc, 여러 줄을 한 번에 파일로
command -v python3        # 명령어 존재 확인 (없으면 종료 상태 1)
echo "메시지" >&2         # 오류 통로로 출력
exit 1                    # 실패 상태로 종료
echo $?                   # 직전 명령의 종료 상태 보기
```

## start.sh

```bash
#!/bin/bash
cd "$(dirname "$0")" || exit 1

if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3를 먼저 설치하세요." >&2
    exit 1
fi

exec python3 chat.py
```
