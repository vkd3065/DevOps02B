# ---------------------------------------------------------------
# 학생 과제: 아래 각 줄이 무엇을 하는지 주석으로 설명을 달아보세요.
# ---------------------------------------------------------------

# 파이썬 3.12 깔린 가벼운 이미지에서 시작
FROM python:3.12-slim


# 작업 폴더를 /app으로 (cd 같은 거인데 없으면 폴더 만듦)
WORKDIR /app

# requirements.txt만 먼저 복사
COPY requirements.txt .

# 빌드할 때 flask, redis 설치 (이미지에 남음)
RUN pip install --no-cache-dir -r requirements.txt

# 나머지 코드 전부 복사.
COPY . .

# root 말고 일반 사용자 만들어서 그걸로 실행
RUN useradd -m appuser
USER appuser

# 제목이랑 색 기본값.
ENV APP_TITLE="문정수의 방명록 v2" \
    THEME_COLOR="#7C3AED"

# 5000번 쓴다고 적어둠.
EXPOSE 5000

# 컨테이너 켤 때마다 앱 실행. CMD는 켤 때 씀.
CMD ["python", "app.py"]
