#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="${ROOT_DIR}/bin"

export PATH="${BIN_DIR}:${PATH}"

"${ROOT_DIR}/scripts/ensure-terraform.sh"

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Falta comando requerido: $1" >&2
    exit 1
  fi
}

need_cmd jq
need_cmd terraform

echo "OK: terraform y jq disponibles"
