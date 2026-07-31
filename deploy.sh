#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

apply_manifests() {
  local dir="$1"
  echo "[deploy] Aplicando manifests de $dir"
  find "$ROOT_DIR/$dir" -maxdepth 1 -type f \( -name '*.yml' -o -name '*.yaml' \) | sort | while read -r file; do
    echo "  -> kubectl apply -f $file"
    kubectl apply -f "$file"
  done
}

echo "[deploy] Iniciando despliegue de Inventrack en Kubernetes"

apply_manifests "00-namespace"
apply_manifests "01-configmaps-secrets"
apply_manifests "02-storage"
apply_manifests "03-mysql"
apply_manifests "04-backend"
apply_manifests "05-frontend"
apply_manifests "06-ingress"

echo "[deploy] Despliegue completado"
