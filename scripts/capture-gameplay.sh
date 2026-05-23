#!/usr/bin/env bash
# Graba un demo reproducible del juego: PNG por frame + MP4 opcional.
# Requiere display virtual en servidores sin pantalla (xvfb-run).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODE_DIR="${ROOT}/code"
ARTIFACTS_DIR="${ROOT}/artifacts"
TIMESTAMP="$(date -u +"%Y%m%dT%H%M%SZ")"
CAPTURE_DIR="${CAPTURE_DIR:-${ARTIFACTS_DIR}/capture-${TIMESTAMP}}"
CAPTURE_SECONDS="${CAPTURE_SECONDS:-8}"
CAPTURE_FPS="${CAPTURE_FPS:-15}"

# Reutilizar Godot de verify-godot si existe
if [[ -z "${GODOT_BIN:-}" ]]; then
  GODOT_BIN="$(find "${ROOT}/.tools/godot" -maxdepth 1 -type f -name 'Godot_*_linux.x86_64' 2>/dev/null | head -n 1)"
fi
if [[ -z "${GODOT_BIN}" || ! -x "${GODOT_BIN}" ]]; then
  echo "Ejecutá primero ./scripts/verify-godot.sh o definí GODOT_BIN." >&2
  exit 1
fi

mkdir -p "${CAPTURE_DIR}"
export CAPTURE_DIR CAPTURE_SECONDS CAPTURE_FPS

echo "Capturando en: ${CAPTURE_DIR}"
echo "Duración: ${CAPTURE_SECONDS}s @ ${CAPTURE_FPS} fps"

run_godot() {
  # Sin --headless: hace falta viewport real (Xvfb en CI/agente).
  "${GODOT_BIN}" --path "${CODE_DIR}" --audio-driver Dummy -s res://tests/demo_playback.gd "$@"
}

if [[ -n "${DISPLAY:-}" ]]; then
  run_godot
elif command -v xvfb-run >/dev/null 2>&1; then
  xvfb-run -a -s "-screen 0 640x360x24" run_godot
else
  echo "No hay DISPLAY ni xvfb-run. En local: export DISPLAY=:0 o instalá xvfb." >&2
  exit 1
fi

FRAME_COUNT="$(find "${CAPTURE_DIR}" -maxdepth 1 -name 'frame_*.png' 2>/dev/null | wc -l | tr -d ' ')"
echo "Frames guardados: ${FRAME_COUNT}"

if command -v ffmpeg >/dev/null 2>&1 && [[ "${FRAME_COUNT}" -gt 0 ]]; then
  VIDEO_PATH="${CAPTURE_DIR}/demo.mp4"
  ffmpeg -y -loglevel warning -framerate "${CAPTURE_FPS}" \
    -i "${CAPTURE_DIR}/frame_%04d.png" \
    -c:v libx264 -pix_fmt yuv420p \
    "${VIDEO_PATH}"
  echo "Video: ${VIDEO_PATH}"
else
  echo "ffmpeg no disponible o sin frames; solo PNG en ${CAPTURE_DIR}"
fi

echo "capture-gameplay: OK"
