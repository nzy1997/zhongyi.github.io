#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TMP_DIR="$(mktemp -d /tmp/cv-layout.XXXXXX)"
trap 'rm -rf "$TMP_DIR"' EXIT

typst compile "$ROOT_DIR/cv/cv.typ" "$TMP_DIR/cv.pdf" >/dev/null
gs -q -dNOPAUSE -dBATCH -sDEVICE=txtwrite -o "$TMP_DIR/cv.txt" "$TMP_DIR/cv.pdf"
HEAD_TXT="$TMP_DIR/head.txt"
sed -n '1,3p' "$TMP_DIR/cv.txt" > "$HEAD_TXT"

if ! rg -q 'OPEN SOURCE CONTRIBUTIONS' "$TMP_DIR/cv.txt"; then
  echo "Missing standalone OPEN SOURCE CONTRIBUTIONS section in rendered CV." >&2
  exit 1
fi

if ! rg -q 'TALKS' "$TMP_DIR/cv.txt"; then
  echo "Missing standalone TALKS section in rendered CV." >&2
  exit 1
fi

if rg -q 'SOFTWARE & TALKS|^ *SOFTWARE$' "$TMP_DIR/cv.txt"; then
  echo "Found old software section heading in rendered CV." >&2
  exit 1
fi

if rg -q 'Student Scholarship|Academic Scholarship' "$TMP_DIR/cv.txt"; then
  echo "Found removed scholarship awards in rendered CV." >&2
  exit 1
fi

if rg -q 'Research Software|JuliaCon talk +[A-Z][a-z]{2} [0-9]{4} .*[–-] [A-Z][a-z]{2} [0-9]{4}' "$TMP_DIR/cv.txt"; then
  echo "Found old software/talk metadata formatting in rendered CV." >&2
  exit 1
fi

if ! rg -q 'Maintainer' "$TMP_DIR/cv.txt"; then
  echo "Missing maintainer label for software entries in rendered CV." >&2
  exit 1
fi

if ! rg -q 'QuantumClifford\.jl' "$TMP_DIR/cv.txt" || ! rg -q 'Contributor' "$TMP_DIR/cv.txt"; then
  echo "Missing QuantumClifford.jl contributor entry in rendered CV." >&2
  exit 1
fi

if rg -q 'Research in quantum error correction, tensor-network methods, and quantum computing\.|Conducting research in quantum many-body methods and quantum information\.|Worked on quantum computing and quantum control problems\.' "$TMP_DIR/cv.txt"; then
  echo "Found detailed research-description lines in Research Positions." >&2
  exit 1
fi

if rg -q '\+86 131-2271-2162' "$HEAD_TXT"; then
  echo "Found phone number in rendered CV heading." >&2
  exit 1
fi

if ! rg -q '倪中一' "$HEAD_TXT"; then
  echo "Missing Chinese name in rendered CV heading." >&2
  exit 1
fi

if rg -q 'Guangzhou, China' "$HEAD_TXT"; then
  echo "Found address line in rendered CV heading." >&2
  exit 1
fi

if ! rg -q 'PhD Student in Advanced Materials' "$HEAD_TXT"; then
  echo "Missing title line in rendered CV heading." >&2
  exit 1
fi

if rg -q 'github\.com/nzy1997' "$HEAD_TXT"; then
  echo "Found GitHub in rendered CV heading." >&2
  exit 1
fi

if ! rg -q '倪中一.*zni573@connect\.hkust-gz\.edu\.cn.*https://nzy1997\.github\.io/|zni573@connect\.hkust-gz\.edu\.cn.*倪中一.*https://nzy1997\.github\.io/|zni573@connect\.hkust-gz\.edu\.cn.*https://nzy1997\.github\.io/.*倪中一' "$HEAD_TXT"; then
  echo "Chinese name, email, and homepage are not on the same heading line." >&2
  exit 1
fi
