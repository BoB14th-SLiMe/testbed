# PLC/SCADA 통신 테스트베드

이 프로젝트는 Docker Compose를 사용하여 Node-RED 기반의 가상 PLC와 SCADA 환경을 구축하고, 둘 사이의 통신을 캡처하는 테스트베드입니다.
사거리 신호등의 신호를 제어하는 SCADA와 PLC 환경을 구축했습니다.

---

## 주요 기능

- **PLC 서비스**: Modbus 서버 역할을 하는 Node-RED 인스턴스
- **SCADA 서비스**: Modbus 클라이언트 역할을 하는 Node-RED 인스턴스
- **Packet Capture**: SCADA 컨테이너의 모든 네트워크 통신을 pcap 파일로 저장

### SCADA UI
신호등 4개

제어판 : 신호등의 동작을 제어합니다.
1. 일반 주기 모드
2. 심야 점멸 모드
3. 전체 적색 모드

---

## 실행 방법

1. Git 저장소를 클론합니다.
   ```bash
   git clone https://github.com/BoB14th-SLiMe/testbed.git

2. 도커 컨테이너를 실행합니다.
- 최초 실행시
   ```bash
   docker-compose up -d --build

- 이후 실행시
  ```bash
  docker-compose up -d

3. PLC, SCADA 접속

- **PLC**: http://localhost:1880
- **SCADA**: http://localhost:1881
- **SCADA UI**: http://localhost:1881/ui

