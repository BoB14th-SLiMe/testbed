# 🚦 PLC/SCADA 통신 테스트베드

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)
[![Node-RED](https://img.shields.io/badge/Node--RED-8F0000?style=flat-square&logo=nodered&logoColor=white)](https://nodered.org/)
[![Modbus TCP](https://img.shields.io/badge/Modbus-TCP-blue?style=flat-square)]()

이 프로젝트는 **Docker Compose**를 사용하여 Node-RED 기반의 가상 PLC와 SCADA 환경을 구축하고, 산업용 통신 프로토콜인 **Modbus TCP**를 통한 실시간 데이터 교환을 시뮬레이션하는 테스트베드입니다.

🎯 **사거리 신호등 제어 시스템**을 통해 실제 산업현장과 유사한 PLC/SCADA 통신 환경을 제공합니다.

## ✨ 주요 기능

### 🏭 시스템 구성
- **PLC 서비스**: Modbus TCP 서버 역할을 하는 Node-RED 인스턴스
  - 신호등 제어 로직 구현 (정상 주기, 심야 점멸, 전체 적색)
  - Modbus 서버(포트 502)를 통한 데이터 제공
- **SCADA 서비스**: Modbus TCP 클라이언트 역할을 하는 Node-RED 인스턴스
  - 실시간 신호등 상태 모니터링
  - 웹 기반 HMI(Human Machine Interface) 제공
- **패킷 캡처**: SCADA 컨테이너의 모든 네트워크 통신을 pcap 파일로 자동 저장

### 🚦 SCADA 제어 시스템
#### 신호등 배치
```
     🚦 3번 (북쪽)
         |
🚦 2번 ──┼── 🚦 4번
      (동쪽)   (서쪽)
         |
     🚦 1번 (남쪽)
```

#### 제어 모드
| 모드 | 설명 | 동작 방식 |
|------|------|-----------|
| 🔄 **일반 주기 모드** | 평상시 신호등 운영 | 남북-동서 방향 순차 신호 |
| 🌙 **심야 점멸 모드** | 야간/새벽 시간대 | 모든 방향 황색 점멸 |
| 🔴 **전체 적색 모드** | 긴급상황/점검시 | 모든 방향 적색 고정 |

## 🚀 실행 방법

### 1. 저장소 클론
```bash
git clone https://github.com/BoB14th-SLiMe/testbed.git
cd testbed
```

### 2. Docker 컨테이너 실행
#### 최초 실행시 (이미지 빌드)
```bash
docker-compose up -d --build
```

#### 이후 실행시
```bash
docker-compose up -d
```

### 3. 시스템 접속
| 서비스 | URL | 설명 |
|--------|-----|------|
| 🏭 **PLC** | [http://localhost:1880](http://localhost:1880) | PLC 제어 로직 및 Modbus 서버 |
| 🖥️ **SCADA** | [http://localhost:1881](http://localhost:1881) | SCADA 모니터링 시스템 |
| 📊 **SCADA UI** | [http://localhost:1881/ui](http://localhost:1881/ui) | 신호등 제어 대시보드 |

## 📊 시스템 모니터링

### 실시간 상태 확인
- **신호등 상태**: 각 방향별 빨강/노랑/초록 램프 상태를 실시간 표시
- **통신 상태**: Modbus TCP 통신 품질 및 연결 상태 모니터링
- **제어 이력**: 모드 변경 및 제어 명령 이력 추적

### 패킷 분석
생성된 pcap 파일을 Wireshark로 열어 Modbus TCP 통신을 상세히 분석할 수 있습니다:
```bash
# 패킷 캡처 파일 위치
./pcap/output.pcap
```

## 🛠️ 기술 스택

- **컨테이너화**: Docker & Docker Compose
- **PLC/SCADA 플랫폼**: Node-RED
- **산업 통신**: Modbus TCP (포트 502)
- **웹 인터페이스**: Node-RED Dashboard
- **패킷 분석**: tcpdump, Wireshark

## 📁 프로젝트 구조

```
SLiME/
├── pcap/                           # 패킷 캡처 파일 저장소
├── settings/                       # Node-RED 설정 파일
├── plc/
│   ├── flows.json                 # PLC Node-RED 플로우 (자동 생성)
│   ├── package.json              # PLC Node.js 의존성
│   ├── plcDockerfile             # PLC 컨테이너 설정
│   └── settings.js               # PLC Node-RED 설정
├── scada/
│   ├── flows.json                # SCADA Node-RED 플로우 (자동 생성)
│   ├── package.json             # SCADA Node.js 의존성
│   ├── scadaDockerfile          # SCADA 컨테이너 설정
│   └── settings.js              # SCADA Node-RED 설정
├── traffic_light_plc.json       # PLC 플로우 내보내기 파일
├── traffic_light_scada.json     # SCADA 플로우 내보내기 파일
├── .gitignore                   # Git 제외 파일 목록
├── docker-compose.yml           # Docker Compose 설정
└── README.md                    # 프로젝트 문서
```

### 주요 파일 설명
- **traffic_light_plc.json**: Node-RED에서 내보낸 PLC 제어 로직 플로우
- **traffic_light_scada.json**: Node-RED에서 내보낸 SCADA 모니터링 플로우
- **pcap/**: SCADA 컨테이너의 네트워크 트래픽 캡처 파일 저장
- **settings/**: Node-RED 런타임 설정 및 보안 구성

## 🔧 커스터마이징

### 신호 타이밍 조정
PLC의 `flows.json`에서 신호등 타이밍을 수정할 수 있습니다:
```javascript
const GREEN_TIME = 5;    // 녹색 신호 시간 (초)
const YELLOW_TIME = 2;   // 황색 신호 시간 (초)
```

### Modbus 레지스터 맵
| 주소 | 설명 |
|------|------|
| 0-2 | 1번 신호등 (빨강/노랑/초록) |
| 3-5 | 2번 신호등 (빨강/노랑/초록) |
| 6-8 | 3번 신호등 (빨강/노랑/초록) |
| 9-11 | 4번 신호등 (빨강/노랑/초록) |

## 🎯 사용 사례

- **산업보안 교육**: PLC/SCADA 시스템의 보안 취약점 분석
- **통신 프로토콜 학습**: Modbus TCP 프로토콜 구조 이해
- **시스템 통합 테스트**: 다양한 산업용 장비간 통신 테스트
- **사이버 위협 시뮬레이션**: 산업제어시스템 대상 공격 시나리오 연구

## 📞 문의 및 기여

프로젝트에 대한 문의사항이나 개선사항이 있으시면 언제든 Issue를 등록해주세요!

---

<div align="center">

**🔒 Industrial Control Systems Security Research**

*Powered by BoB 14th SLiMe Team*

</div>
