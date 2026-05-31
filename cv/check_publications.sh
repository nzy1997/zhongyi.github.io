#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
TMP_DIR="$(mktemp -d /tmp/cv-publications.XXXXXX)"
trap 'rm -rf "$TMP_DIR"' EXIT

typst compile "$ROOT_DIR/cv/cv.typ" "$TMP_DIR/cv.pdf" >/dev/null
gs -q -dNOPAUSE -dBATCH -sDEVICE=txtwrite -sOutputFile="$TMP_DIR/cv.txt" "$TMP_DIR/cv.pdf" >/dev/null

if rg -q '\[Online\]|Available:' "$TMP_DIR/cv.txt"; then
  echo "Found online-style bibliography formatting in rendered CV." >&2
  exit 1
fi

for arxiv_id in 2604.14269 2409.20025 2505.23373; do
  if ! rg -q "arXiv:${arxiv_id}" "$TMP_DIR/cv.txt"; then
    echo "Missing expected arXiv citation format for ${arxiv_id}." >&2
    exit 1
  fi
done

typst query "$ROOT_DIR/cv/cv.typ" strong --field body --format json --pretty > "$TMP_DIR/strong.json"

if ! rg -q 'Zhongyi Ni' "$TMP_DIR/strong.json"; then
  echo "Missing bolded Zhongyi Ni author markup in publications." >&2
  exit 1
fi
