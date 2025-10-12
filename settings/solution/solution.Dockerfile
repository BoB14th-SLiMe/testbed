# 베이스 이미지
FROM python:3.12-slim

# C++ 빌드 도구, cmake, tshark/pcap 등 설치
RUN apt-get update && apt-get install -y \
    build-essential cmake \
    tshark libpcap-dev ca-certificates tzdata procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# C++ 소스 코드 복사
COPY ./tcp_datagram_parser /app/pcap_parser_src

# C++ 프로젝트 빌드
WORKDIR /app/pcap_parser_src
RUN cmake -B build && cmake --build build

# 컴파일된 바이너리를 실행 경로로 복사 (실행 파일 이름을 pcap_parser로 변경)
RUN cp /app/pcap_parser_src/build/parser /usr/local/bin/pcap_parser

# 빌드 후 소스 코드 정리 (이미지 용량 최적화)
RUN rm -rf /app/pcap_parser_src

# 원래 작업 디렉토리로 복귀
WORKDIR /app

# 파이썬 의존성
COPY settings/solution/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# 스크립트 복사
COPY settings/solution/entrypoint.sh /app/entrypoint.sh
COPY settings/solution/json2csv_parser.py /app/json2csv_parser.py
COPY settings/solution/jsonl_bulk_indexer.py /app/jsonl_bulk_indexer.py
RUN apt-get update && apt-get install -y dos2unix && \
    dos2unix /app/entrypoint.sh && \
    chmod 755 /app/entrypoint.sh

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]