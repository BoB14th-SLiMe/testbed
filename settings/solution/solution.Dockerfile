FROM python:3.12-slim

# tshark/pcap 등 설치
RUN apt-get update && apt-get install -y \
    tshark libpcap-dev ca-certificates tzdata procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# (중요) 프로젝트 루트의 C++ 바이너리 복사
COPY pcap_parser /usr/local/bin/pcap_parser
RUN chmod +x /usr/local/bin/pcap_parser

# 파이썬 의존성
COPY settings/solution/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# 스크립트 복사
COPY settings/solution/entrypoint.sh /app/entrypoint.sh
COPY settings/solution/json2csv_parser.py /app/json2csv_parser.py
COPY settings/solution/jsonl_bulk_indexer.py /app/jsonl_bulk_indexer.py
RUN apt-get update && apt-get install -y dos2unix && \
    dos2unix /app/entrypoint.sh && \
    chmod 755 /app/entrypoint.sh && \
    ls -l /app/entrypoint.sh

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]