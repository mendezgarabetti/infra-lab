#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROSTER_JSON="${ROOT_DIR}/student_instances.json"
OUT_CSV="${ROOT_DIR}/student_passwords.csv"

if [[ ! -f "${ROSTER_JSON}" ]]; then
  echo "No existe ${ROSTER_JSON}. Ejecuta primero el provisionamiento." >&2
  exit 1
fi

gen_password() {
  # head -c cierra el pipe antes de que tr termine de leer /dev/urandom,
  # lo que genera SIGPIPE (exit 141). Se aisla pipefail en un subshell
  # para que ese SIGPIPE no aborte el script completo.
  (
    set +o pipefail
    tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 14
  )
}

echo "student_id,username,public_ip,password" > "${OUT_CSV}"

jq -r 'to_entries[] | [.key, .value.username, .value.public_ip] | @tsv' "${ROSTER_JSON}" | \
while IFS=$'\t' read -r sid username ip; do
  password="$(gen_password)"

  echo "==> Configurando ${username} (${ip})"

  remote_cmd="echo '${username}:${password}' | sudo chpasswd && sudo passwd -u '${username}' >/dev/null 2>&1 || true; echo 'PasswordAuthentication yes' | sudo tee /etc/ssh/sshd_config.d/10-classroom.conf >/dev/null && sudo systemctl restart ssh"

  ssh -n -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 "${username}@${ip}" "${remote_cmd}"

  echo "${sid},${username},${ip},${password}" >> "${OUT_CSV}"
done

chmod 600 "${OUT_CSV}"
echo "Listo. Contraseñas guardadas en ${OUT_CSV} (no se sube a git)."
