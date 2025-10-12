import argparse, glob, json, os, re
from elasticsearch import Elasticsearch, helpers
from dateutil import parser as dtp

def ensure_index(es, index):
    if es.indices.exists(index=index):
        return
    mapping = {
        "mappings": {
            "properties": {
                "@timestamp": {"type": "date"},
                "sip": {"type": "ip"},
                "dip": {"type": "ip"},
                "sp": {"type": "integer"},
                "dp": {"type": "integer"},
                "sq": {"type": "long"},
                "ak": {"type": "long"},
                "fl": {"type": "integer"},
                "tid": {"type": "integer"},
                "d": {"type": "object"},
            }
        }
    }
    es.indices.create(index=index, body=mapping)
    print(f"[ES] created index: {index}")

def norm_doc(obj: dict) -> dict:
    doc = dict(obj)
    # ts -> @timestamp
    if "ts" in doc and "@timestamp" not in doc:
        doc["@timestamp"] = doc.pop("ts")
    # 보장: ISO8601 문자열 (숫자인 경우 epoch로부터 변환 시도 가능하지만 여기선 그대로)
    # d: 문자열이면 JSON으로
    d = doc.get("d")
    if isinstance(d, str):
        try:
            doc["d"] = json.loads(d)
        except Exception:
            pass
    return doc

def infer_proto_from_path(path: str) -> str:
    base = os.path.basename(path)
    # ex) modbus_tcp.jsonl, s7comm.jsonl, tcp_session.jsonl ...
    m = re.match(r"([^.]+)\.jsonl$", base)
    return m.group(1) if m else "unknown"

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--es", required=True, help="ES host (e.g., http://elasticsearch:9200)")
    ap.add_argument("--prefix", default="packets")
    ap.add_argument("--glob", default="/pcap/data/*.jsonl")
    ap.add_argument("--batch", type=int, default=500)
    args = ap.parse_args()

    es = Elasticsearch(args.es)

    files = sorted(glob.glob(args.glob))
    total_docs = 0
    for fp in files:
        proto = infer_proto_from_path(fp)
        index = f"{args.prefix}-{proto}"
        ensure_index(es, index)

        actions = []
        with open(fp, "r") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    obj = json.loads(line)
                except Exception:
                    continue
                doc = norm_doc(obj)
                actions.append({"_index": index, "_source": doc})
                if len(actions) >= args.batch:
                    helpers.bulk(es, actions)
                    total_docs += len(actions)
                    actions = []
        if actions:
            helpers.bulk(es, actions)
            total_docs += len(actions)
        print(f"[ES] indexed {fp} -> {index}")

    print(f"✅ total indexed docs: {total_docs}")

if __name__ == "__main__":
    main()