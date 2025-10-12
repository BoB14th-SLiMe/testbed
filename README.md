# 🚦 4-Way Intersection PLC/SCADA Testbed

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/) [![Node-RED](https://img.shields.io/badge/Node--RED-8F0000?style=flat-square&logo=nodered&logoColor=white)](https://nodered.org/) [![Modbus TCP](https://img.shields.io/badge/Modbus-TCP-blue?style=flat-square)]()

이 프로젝트는 **Docker Compose**를 사용하여 4개의 가상 PLC와 1개의 SCADA 시스템을 구축하는 테스트베드입니다. 산업용 통신 프로토콜인 **Modbus TCP**를 통해 실시간 데이터를 교환하는 **사거리 신호등 제어 시스템**을 시뮬레이션하며, 실제 산업 현장과 유사한 통신 환경을 제공합니다.

---

## ✨ 주요 기능

* **가상 산업 환경**: 4개의 PLC와 1개의 SCADA를 독립된 컨테이너로 구성하여 다중 장치 환경을 시뮬레이션합니다.
* **실시간 모니터링 및 제어**: SCADA 대시보드를 통해 4개 교차로의 신호등 상태를 통합 관제하고, 운전 모드를 원격으로 제어할 수 있습니다.
* **네트워크 패킷 캡처**: SCADA와 PLC 간의 모든 Modbus TCP 통신을 `pcap` 파일로 자동 캡처하여 상세한 프로토콜 분석을 지원합니다.

---

## 🚀 실행 방법

### **1. 사전 요구사항**

* [Docker](https://www.docker.com/products/docker-desktop/) 및 Docker Compose 설치

### **2. 저장소 복제**

```bash
git clone git clone https://github.com/BoB14th-SLiMe/testbed.git
cd testbed
git checkout multi_plc
```

### **3. Docker 컨테이너 실행**

아래 명령어를 실행하면 필요한 Docker 이미지를 빌드하고 모든 서비스를 백그라운드에서 실행합니다.

```bash
docker-compose up --build -d
```

### **4. 시스템 접속**

| 서비스                  | URL                                                     | 포트 (Host:Container) | 설명                   |
| :---------------------- | :------------------------------------------------------ | :-------------------- | :--------------------- |
| 🖥️ **SCADA** | **[http://localhost:1880/ui](http://localhost:1880/ui)** | `1880:1880`           | **통합 관제 대시보드** |
| 🚦 **PLC 1** | [http://localhost:1881](http://localhost:1881)           | `1881:1880` / `502:502` | A 사거리 PLC           |
| 🚦 **PLC 2** | [http://localhost:1882](http://localhost:1882)           | `1882:1880` / `503:502` | B 사거리 PLC           |
| 🚦 **PLC 3** | [http://localhost:1883](http://localhost:1883)           | `1883:1880` / `504:502` | C 사거리 PLC           |
| 🚦 **PLC 4** | [http://localhost:1884](http://localhost:1884)           | `1884:1880` / `505:502` | D 사거리 PLC           |

---

## 📁 프로젝트 구조

```
testbed/
├── pcap/
│   └── output.pcap         # 네트워크 패킷 캡처 파일
├── settings/
│   ├── plc/
│   │   ├── flows1.json     # PLC 1번 Node-RED 플로우
│   │   ├── flows2.json     # PLC 2번 Node-RED 플로우
│   │   ├── flows3.json     # ...
│   │   ├── flows4.json
│   │   ├── package.json
│   │   ├── plc.Dockerfile  # 모든 PLC가 공용으로 사용하는 Dockerfile
│   │   └── settings.js
│   └── scada/
│       ├── flows.json      # SCADA Node-RED 플로우
│       ├── package.json
│       ├── scada.Dockerfile
│       └── settings.js
├── .gitignore
├── docker-compose.yml      # 서비스 및 네트워크 구성 파일
└── README.md
```

### **주요 파일 설명**

* `docker-compose.yml`: **1개의 SCADA**와 **4개의 PLC** 컨테이너를 정의하고 네트워크 및 볼륨을 설정합니다. PLC 서비스들은 **하나의 공통 이미지(`testbed-plc:latest`)를 공유**하여 효율성을 높였습니다.
* `settings/plc/flowsX.json`: 각 PLC 컨테이너에 개별적으로 마운트되는 Node-RED 플로우 파일입니다.
* `pcap/output.pcap`: `netshoot` 컨테이너가 SCADA의 네트워크 인터페이스를 미러링하여 생성하는 통신 기록 파일입니다. Wireshark 등으로 열어 Modbus TCP 통신을 분석할 수 있습니다.

---

## 🛠️ 기술 스택

* **가상화**: **Docker & Docker Compose**
* **PLC/SCADA 플랫폼**: **Node-RED**
* **산업 프로토콜**: **Modbus TCP**
* **패킷 분석**: **Netshoot (tshark)**

---

## 🎯 활용 분야

* **OT/ICS 보안 연구**: 산업 제어 시스템의 통신 패턴 분석 및 보안 취약점 연구
* **프로토콜 학습**: Modbus TCP 프로토콜의 구조와 동작 방식 실습
* **보안 관제 시나리오 개발**: 다중 PLC 환경에서의 이상 트래픽 탐지 및 분석
* **디지털 트윈**: 물리적 시스템의 디지털 복제본을 통한 시뮬레이션 및 테스트

## 📞 문의 및 기여

프로젝트에 대한 문의사항이나 개선사항이 있으시면 언제든 Issue를 등록해주세요!

---

<div align="center">

**🔒 Industrial Control Systems Security Research**

*Powered by BoB 14th SLiMe Team*

</div>
