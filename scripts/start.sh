#!/usr/bin/env bash
# Start the whole lab stack and show where to open the 3 ports.
#   bash scripts/start.sh          start web app + Redis + Prometheus + Grafana
#   bash scripts/start.sh status   show what's running and the links
#   bash scripts/start.sh stop     stop and remove the lab containers
set -uo pipefail
cd "$(dirname "$0")/.."

# name|port|health-check path
SERVICES=(
  "Web app|8000|/health"
  "Grafana|3000|/api/health"
  "Prometheus|9090|/-/ready"
)

url_for() {   # the address to open in YOUR browser
  if [[ -n "${CODESPACE_NAME:-}" && -n "${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-}" ]]; then
    echo "https://${CODESPACE_NAME}-$1.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
  else
    echo "http://localhost:$1"
  fi
}

is_up() { curl -fs -m 2 "http://localhost:$1$2" >/dev/null; }

show_links() {
  echo
  printf '  %-11s %-6s %-58s %s\n' "SERVICE" "PORT" "OPEN IN YOUR BROWSER" "STATUS"
  for s in "${SERVICES[@]}"; do
    IFS='|' read -r name port path <<<"$s"
    if is_up "$port" "$path"; then st="✅ up"; else st="❌ not responding"; fi
    printf '  %-11s %-6s %-58s %s\n' "$name" "$port" "$(url_for "$port")" "$st"
  done
  echo
  if [[ -n "${CODESPACE_NAME:-}" ]]; then
    echo "  Codespaces: you can also use the PORTS tab (next to TERMINAL) → 🌐 icon."
  elif grep -qi microsoft /proc/version 2>/dev/null; then
    echo "  WSL: open the links in your normal Windows browser."
  fi
  echo "  In this terminal, 'curl localhost:8000' always works."
}

case "${1:-start}" in
  stop)
    docker compose --profile monitoring down
    ;;
  status)
    docker compose --profile monitoring ps
    show_links
    ;;
  start)
    command -v docker >/dev/null || { echo "❌ docker not found. Finish the setup first."; exit 1; }
    project="$(docker compose config --format json 2>/dev/null | python3 -c 'import json,sys; print(json.load(sys.stdin)["name"])' 2>/dev/null || basename "$PWD")"
    blocked=0
    for port in 8000 3000 9090; do
      holder=$(docker ps --filter "publish=$port" --format '{{.Names}} {{.Label "com.docker.compose.project"}}' | awk -v p="$project" '$2 != p {print $1}' | head -1)
      if [[ -n "$holder" ]]; then
        echo "⚠️  Port $port is already used by container '$holder' (maybe from Lab 3)."
        echo "    Free it with:  docker rm -f $holder"
        blocked=1
      fi
    done
    [[ $blocked -eq 1 ]] && { echo "Then run this script again."; exit 1; }

    echo "🚀 Starting web app, Redis, Prometheus and Grafana..."
    docker compose --profile monitoring up -d --build || { echo "❌ Start failed. See: docker compose logs"; exit 1; }
    echo -n "⏳ Waiting for all 3 ports"
    for _ in $(seq 1 60); do
      ready=0
      for s in "${SERVICES[@]}"; do
        IFS='|' read -r _ port path <<<"$s"
        is_up "$port" "$path" && ready=$((ready+1))
      done
      [[ $ready -eq 3 ]] && break
      echo -n "."; sleep 2
    done
    echo
    show_links
    echo "  Stop everything with: bash scripts/start.sh stop"
    if [[ $ready -ne 3 ]]; then
      echo "❌ Not all ports answered. Check: docker compose --profile monitoring ps / docker compose logs"
      exit 1
    fi
    ;;
  *)
    echo "Usage: bash scripts/start.sh [start|status|stop]"; exit 1 ;;
esac
