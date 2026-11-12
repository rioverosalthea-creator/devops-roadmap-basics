#!/usr/bin/env bash
# Optional: install the instructor's VS Code extensions on a Windows PC (WSL).
# Run it in the VS Code terminal (bottom-left must say "WSL: Ubuntu"):
#   bash scripts/vscode/install.sh          # asks before installing
#   bash scripts/vscode/install.sh -y       # no question
#
# Each extension is installed on both sides, so it works whatever kind it is:
#   - Windows side (themes, Git UI, the WSL extension itself) via cmd.exe
#   - Ubuntu side (Python, Docker, Terraform...) via the VS Code server
set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
LIST="$HERE/extensions.txt"
YES=0; [[ "${1:-}" == "-y" ]] && YES=1

if ! command -v code >/dev/null; then
  echo "❌ 'code' not found. Open this folder in VS Code from Ubuntu (code .) and run the script in its terminal."
  exit 1
fi
if [[ -z "${WSL_DISTRO_NAME:-}" ]]; then
  echo "⚠️  This doesn't look like WSL. Installing for this machine only."
fi

mapfile -t EXTS < <(grep -vE '^[[:space:]]*(#|$)' "$LIST" | tr -d '\r')
echo "📦 ${#EXTS[@]} extensions in $(basename "$LIST"):"
printf '   %s\n' "${EXTS[@]}"

if [[ $YES -eq 0 ]]; then
  read -r -p "Install them? [y/N] " answer
  [[ "$answer" =~ ^[Yy]$ ]] || { echo "Cancelled. Nothing installed."; exit 0; }
fi

win_install() {   # VS Code on Windows (needs WSL interop; runs from C:\ to avoid UNC-path warnings)
  command -v cmd.exe >/dev/null || return 0
  (cd /mnt/c && cmd.exe /c code --install-extension "$1" --force >/dev/null 2>&1)
}

ok=0; failed=()
for ext in "${EXTS[@]}"; do
  printf '→ %-48s' "$ext"
  win_install "$ext"
  if [[ "$ext" == "ms-vscode-remote.remote-wsl" ]]; then
    echo "✅ (Windows)"; ok=$((ok+1)); continue      # only needed on the Windows side
  fi
  if code --install-extension "$ext" --force >/dev/null 2>&1; then
    echo "✅"; ok=$((ok+1))
  else
    echo "❌"; failed+=("$ext")
  fi
done

echo
echo "Done: $ok installed, ${#failed[@]} failed."
if (( ${#failed[@]} )); then
  echo "Failed (try again, or install from the Extensions panel):"
  printf '   %s\n' "${failed[@]}"
fi
echo "Reload VS Code: Ctrl+Shift+P → 'Developer: Reload Window'."
