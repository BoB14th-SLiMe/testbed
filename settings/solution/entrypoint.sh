#!/bin/bash
set -euo pipefail

INTERVAL="${INTERVAL:-30}"
DATA_DIR="/pcap/data"
OUT_DIR="/pcap/output"
ES_HOST="${ES_HOST:-http://elasticsearch:9200}"
ES_INDEX_PREFIX="${ES_INDEX_PREFIX:-packets}"

mkdir -p "$DATA_DIR" "$OUT_DIR"

echo "=============================="
echo "🟢 SLM Solution Start"
echo "INTERVAL: ${INTERVAL}s"
echo "ES_HOST : ${ES_HOST}"
echo "INDEX   : ${ES_INDEX_PREFIX}-<protocol>"
echo "=============================="

sleep 5

while true; do
  TS="$(date +'%Y%m%d_%H%M%S')"
  PCAP="/pcap/pcap_${TS}.pcap"

  echo ""
  echo "⏱️  [${TS}] Capturing ${INTERVAL}s → ${PCAP}"
  timeout "${INTERVAL}s" tshark -i eth0 -w "${PCAP}" || true

  echo "🔧 [${TS}] Parsing pcap → csv/jsonl (C++)"
  /usr/local/bin/pcap_parser "${PCAP}"

  echo "🧩 [${TS}] Running high-performance Python parser (multiprocessing)"
  python3 /app/json2csv_parser.py  # 너 코드 그대로 실행됨 (data → output)

  echo "📦 [${TS}] Indexing JSONL to Elasticsearch"
  python3 /app/jsonl_bulk_indexer.py \
    --es "${ES_HOST}" \
    --prefix "${ES_INDEX_PREFIX}" \
    --glob "${DATA_DIR}/*.jsonl"

  echo "✅ [${TS}] Batch done."
done