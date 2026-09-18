#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JSON_FILE="${ROOT_DIR}/student_instances.json"
OUT_FILE="${ROOT_DIR}/student_access.csv"

if [[ ! -f "${JSON_FILE}" ]]; then
  echo "No existe ${JSON_FILE}. Ejecuta scripts/apply.sh primero." >&2
  exit 1
fi

jq -r '
  ["student_id","droplet_name","username","public_ip","private_ip","ssh_command"],
  (to_entries[] | [
    .key,
    .value.droplet_name,
    .value.username,
    .value.public_ip,
    .value.private_ip,
    .value.ssh_command
  ])
  | @csv
' "${JSON_FILE}" > "${OUT_FILE}"

echo "Planilla generada: ${OUT_FILE}"
