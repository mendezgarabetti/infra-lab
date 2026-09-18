#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="${ROOT_DIR}/bin"
TF_BIN="${BIN_DIR}/terraform"
TF_VERSION="1.9.8"

if command -v terraform >/dev/null 2>&1; then
  exit 0
fi

if [[ -x "${TF_BIN}" ]]; then
  exit 0
fi

mkdir -p "${BIN_DIR}"

os="$(uname -s | tr '[:upper:]' '[:lower:]')"
arch="$(uname -m)"

case "${arch}" in
  x86_64)
    arch="amd64"
    ;;
  aarch64|arm64)
    arch="arm64"
    ;;
  *)
    echo "Arquitectura no soportada para instalacion automatica de Terraform: ${arch}" >&2
    exit 1
    ;;
esac

zip_name="terraform_${TF_VERSION}_${os}_${arch}.zip"
url="https://releases.hashicorp.com/terraform/${TF_VERSION}/${zip_name}"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

curl -fsSL "${url}" -o "${tmp_dir}/${zip_name}"
unzip -qo "${tmp_dir}/${zip_name}" -d "${tmp_dir}"
install -m 0755 "${tmp_dir}/terraform" "${TF_BIN}"

echo "Terraform ${TF_VERSION} instalado en ${TF_BIN}"
