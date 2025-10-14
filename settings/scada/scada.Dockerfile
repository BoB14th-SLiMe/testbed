# 1. 베이스 이미지로 Node-RED 공식 이미지를 사용합니다.
FROM nodered/node-red:latest

# 2. Node-RED가 데이터를 저장하고 읽는 기본 디렉토리로 이동합니다.
#    이 폴더는 이미지 안에서 생성됩니다.
WORKDIR /data

# 3. 로컬의 설정 파일들을 이미지 안의 /data 폴더로 복사합니다.
#    빌드 컨텍스트(.)는 docker-compose.yml이 있는 프로젝트 최상위 경로입니다.
COPY package.json .
COPY flows.json .
COPY settings.js .

# 4. package.json에 명시된 추가 노드들(modbus, dashboard 등)을 이미지에 설치합니다.
#    --unsafe-perm 옵션은 루트 권한으로 설치 시 발생할 수 있는 문제를 방지합니다.
RUN npm install --unsafe-perm --no-update-notifier --no-fund --only=production

# 5. Node-RED는 기본적으로 'node-red'라는 사용자로 실행됩니다.
#    따라서 WORKDIR(/data)의 소유권을 이 사용자에게 넘겨주어야 합니다.
#    (이 부분은 공식 이미지에서 자동으로 처리될 수 있으나, 명시적으로 해주는 것이 안전합니다.)
USER root
RUN chown -R node-red:node-red /data
USER node-red

# 컨테이너 시작 시 Node-RED를 실행합니다.
# /data 폴더에 설정 파일들이 있으므로 별도 옵션 없이 실행해도 자동으로 로드됩니다.
CMD ["node-red"]