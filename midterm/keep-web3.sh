#!/bin/bash
# ============================================
# web 컨테이너를 항상 N개(기본 3개)로 유지하는 감시 스크립트
# 사용법: ./keep-web3.sh [원하는_개수] [확인_간격(초)]
# 멈추기: Ctrl+C (백그라운드로 돌렸다면 kill <PID>)
# ============================================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/../guestbook" || exit 1      # compose.yaml이 있는 곳으로

DESIRED=${1:-3}                              # 원하는 상태: web 3개
INTERVAL=${2:-10}                            # 10초마다 확인
LOG="$SCRIPT_DIR/keep-web3.log"

echo "감시 시작: web ${DESIRED}개 유지, ${INTERVAL}초마다 확인"
while true; do
    # 현재 상태: 실행 중(running)인 web 컨테이너 개수
    RUNNING=$(docker compose ps -q --status running web | wc -l)

    if [ "$RUNNING" -lt "$DESIRED" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') web ${RUNNING}개 → ${DESIRED}개로 복구" | tee -a "$LOG"
        docker compose up -d --scale web="$DESIRED" > /dev/null 2>&1
    fi
    sleep "$INTERVAL"
done
