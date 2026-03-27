#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/eww"
DESKTOP_ENV="${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}"

if echo "$DESKTOP_ENV" | tr '[:upper:]' '[:lower:]' | grep -q "gnome"; then
  echo "[run] GNOME detected. This widget setup is not supported on GNOME due to Eww incompatibility."
  exit 1
fi

if ! command -v eww >/dev/null 2>&1; then
  echo "[run] eww is not installed. Run $ROOT_DIR/scripts/setup.sh first."
  exit 1
fi

if [[ ! -f "$TARGET_DIR/eww.yuck" ]]; then
  echo "[run] Config not found at $TARGET_DIR. Run $ROOT_DIR/scripts/setup.sh first."
  exit 1
fi

echo "[run] Starting eww daemon"
eww --config "$TARGET_DIR" daemon

echo "[run] Opening widgets"
eww --config "$TARGET_DIR" open clock
eww --config "$TARGET_DIR" open visualizer_window

echo "[run] Widgets started"
