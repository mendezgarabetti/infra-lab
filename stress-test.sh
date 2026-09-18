#!/usr/bin/env bash

set -euo pipefail

URL="http://localhost:8080"
TOTAL_REQUESTS=100

echo "Iniciando prueba de carga rápida contra ${URL}"
echo "Total de peticiones: ${TOTAL_REQUESTS}"
echo "--------------------------------------------------"

for i in $(seq 1 "${TOTAL_REQUESTS}"); do
  printf "[%03d] " "${i}"
  curl -s "${URL}"
done

echo "--------------------------------------------------"
echo "Prueba finalizada"
