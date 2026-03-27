#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/eww"

DESKTOP_ENV="${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}"

if [[ "${EUID}" -eq 0 ]]; then
  printf '[setup] Do not run setup as root. Run it as your normal user.\n'
  exit 1
fi

log() {
  printf '[setup] %s\n' "$1"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

SUDO=""
if [[ "${EUID}" -ne 0 ]] && have_cmd sudo; then
  SUDO="sudo"
fi

install_with_apt() {
  log "Using apt-get"
  $SUDO apt-get update
  $SUDO apt-get install -y cava

  if ! have_cmd eww; then
    if ! $SUDO apt-get install -y eww 2>/dev/null; then
      log "Could not install eww from apt repositories automatically."
      log "Install eww manually, then re-run this setup script."
    fi
  fi
}

install_with_yay() {
  log "Using yay"
  yay -Sy --noconfirm cava eww
}

install_with_dnf() {
  log "Using dnf"
  $SUDO dnf install -y cava eww
}

install_with_zypper() {
  log "Using zypper"
  $SUDO zypper --non-interactive install cava eww
}

install_dependencies() {
  if have_cmd apt-get; then
    install_with_apt
  elif have_cmd yay; then
    install_with_yay
  elif have_cmd dnf; then
    install_with_dnf
  elif have_cmd zypper; then
    install_with_zypper
  else
    log "Unsupported package manager."
    log "Please install dependencies manually: eww, cava"
  fi
}

write_eww_root_files() {
  cat >"$TARGET_DIR/eww.yuck" <<'EOF'
(include "./ClockRainmeter/variables.yuck")
(include "./ClockRainmeter/clock.yuck")

(include "./CavaVisualizer/variables.yuck")
(include "./CavaVisualizer/cava.yuck")
EOF

  cat >"$TARGET_DIR/eww.scss" <<'EOF'
@import "./ClockRainmeter/style.scss";
@import "./CavaVisualizer/style.scss";
EOF
}

log "Installing dependencies"
install_dependencies

if echo "$DESKTOP_ENV" | tr '[:upper:]' '[:lower:]' | grep -q "gnome"; then
  log "Warning: GNOME detected. These widgets are not supported on GNOME due to Eww incompatibility."
fi

log "Setting up widget config at: $TARGET_DIR"
mkdir -p "$TARGET_DIR"
rm -rf "$TARGET_DIR/ClockRainmeter" "$TARGET_DIR/CavaVisualizer"
cp -r "$ROOT_DIR/ClockRainmeter" "$TARGET_DIR/"
cp -r "$ROOT_DIR/CavaVisualizer" "$TARGET_DIR/"
write_eww_root_files

if ! have_cmd eww; then
  log "Warning: eww was not found after setup."
  log "Install eww manually to run widgets."
fi

if ! have_cmd cava; then
  log "Warning: cava was not found after setup."
  log "Install cava manually to use visualizer."
fi

log "Setup complete."
log "Run widgets with: $ROOT_DIR/scripts/run.sh"
log "Or manually:"
log "  eww --config $TARGET_DIR daemon"
log "  eww --config $TARGET_DIR open clock"
log "  eww --config $TARGET_DIR open visualizer_window"
