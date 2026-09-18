#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROSTER_JSON="${ROOT_DIR}/student_instances.json"

if [[ ! -f "${ROSTER_JSON}" ]]; then
  echo "No existe ${ROSTER_JSON}." >&2
  exit 1
fi

jq -r 'to_entries[] | [.key, .value.username, .value.public_ip] | @tsv' "${ROSTER_JSON}" | \
while IFS=$'\t' read -r sid username ip; do
  echo "==> Bloqueando password auth en ${username} (${ip})"

  remote_cmd='sudo rm -f /etc/ssh/sshd_config.d/10-classroom.conf && sudo passwd -l "$(whoami)" >/dev/null 2>&1 || true; sudo systemctl restart ssh'

  ssh -n -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 "${username}@${ip}" "${remote_cmd}"
done

echo "Password auth deshabilitado en todas las VMs. Acceso vuelve a ser solo por clave SSH."
