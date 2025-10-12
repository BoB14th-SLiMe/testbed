FROM nodered/node-red:latest

# 사용자 패키지 설치를 위한 공식 권장 디렉토리로 이동
WORKDIR /usr/src/node-red

# package.json을 복사하고 의존성 설치
COPY ./settings/plc/package.json .
RUN npm install

# 💡 중요: /data 디렉토리의 소유권을 node-red 사용자로 변경
# 이렇게 하면 컨테이너가 실행될 때 /data 폴더에 대한 모든 쓰기 권한을 가집니다.
USER root
RUN chown -R node-red:node-red /data
USER node-red

# 컨테이너 시작 시 Node-RED를 실행
# --settings /data/settings.js 옵션을 추가하여 설정 파일을 명시적으로 지정합니다.
CMD ["node-red", "--settings", "/data/settings.js"]