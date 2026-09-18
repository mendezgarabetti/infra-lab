#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="${ROOT_DIR}/terraform"
BIN_DIR="${ROOT_DIR}/bin"

export PATH="${BIN_DIR}:${PATH}"

"${ROOT_DIR}/scripts/ensure-terraform.sh"

if [[ -z "${DIGITALOCEAN_TOKEN:-}" ]]; then
  echo "Define DIGITALOCEAN_TOKEN en el entorno antes de ejecutar." >&2
  exit 1
fi

cd "${TF_DIR}"
export TF_VAR_do_token="${DIGITALOCEAN_TOKEN}"

terraform destroy -auto-approve

echo "Infraestructura destruida."
