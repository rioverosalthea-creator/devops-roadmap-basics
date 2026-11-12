#!/usr/bin/env bash
# Stop and remove everything the labs started, and nothing else.
#   bash scripts/cleanup.sh         stop + remove lab containers (keeps images for next time)
#   bash scripts/cleanup.sh --all   also remove the lab's images and volumes (frees disk space)
#
# Only touches what the labs create:
#   Lab 3: web1, my-app (+ hello-world test containers)
#   Lab 4/6: the Compose stack in this folder (web, redis, prometheus, grafana)
#   Lab 6 stretch: terraform-nginx
set -uo pipefail
cd "$(dirname "$0")/.."

ALL=0; [[ "${1:-}" == "--all" ]] && ALL=1
command -v docker >/dev/null || { echo "docker not found: nothing to clean."; exit 0; }

echo "🧹 Stopping the lab containers..."

# Lab 4 / Lab 6: the Compose stack (all profiles, so Grafana + Prometheus too)
if [[ $ALL -eq 1 ]]; then
  docker compose --profile monitoring down --remove-orphans --volumes --rmi local 2>&1 | grep -vE '^\s*$' | sed 's/^/   /'
else
  docker compose --profile monitoring down --remove-orphans 2>&1 | grep -vE '^\s*$' | sed 's/^/   /'
fi

# Lab 6 stretch: prefer Terraform's own destroy so its state stays correct
if [[ -f iac/docker-stretch/terraform.tfstate ]] && command -v terraform >/dev/null; then
  (cd iac/docker-stretch && terraform destroy -auto-approve -input=false >/dev/null 2>&1) && echo "   terraform-nginx destroyed (terraform destroy)"
fi

# Lab 3 containers by name, and leftover hello-world runs
for name in web1 my-app terraform-nginx; do
  if docker ps -a --format '{{.Names}}' | grep -qx "$name"; then
    docker rm -f "$name" >/dev/null && echo "   removed $name"
  fi
done
hello=$(docker ps -aq --filter ancestor=hello-world)
[[ -n "$hello" ]] && docker rm -f $hello >/dev/null && echo "   removed hello-world test containers"

if [[ $ALL -eq 1 ]]; then
  echo "🗑️  Removing lab images..."
  for img in my-app:v1 hello-world:latest nginx:alpine redis:7-alpine prom/prometheus:v2.53.0 grafana/grafana:11.1.0; do
    docker image inspect "$img" >/dev/null 2>&1 && docker rmi "$img" >/dev/null 2>&1 && echo "   removed image $img"
  done
fi

echo
echo "✅ Done. Containers still running:"
running=$(docker ps --format '{{.Names}}  ({{.Image}})' | sed 's/^/   /')
echo "${running:-   none}"
if [[ -n "${CODESPACE_NAME:-}" ]]; then
  echo
  echo "💡 Last step: stop this Codespace to save your free hours:"
  echo "   gh codespace stop -c \"$CODESPACE_NAME\"    (or github.com/codespaces → ⋯ → Stop codespace)"
fi
