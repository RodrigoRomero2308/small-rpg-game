#!/usr/bin/env bash
# Genera captura del juego y la publica donde el agente/PR de Cursor pueden referenciarla.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBLISH_DIR="${CURSOR_ARTIFACTS_DIR:-/opt/cursor/artifacts/visual}"
LATEST_CAPTURE=""

"${ROOT}/scripts/verify-godot.sh" >/dev/null
"${ROOT}/scripts/capture-gameplay.sh"

LATEST_CAPTURE="$(find "${ROOT}/artifacts" -maxdepth 1 -type d -name 'capture-*' 2>/dev/null | sort | tail -n 1)"
if [[ -z "${LATEST_CAPTURE}" || ! -d "${LATEST_CAPTURE}" ]]; then
  echo "No se encontró carpeta artifacts/capture-*" >&2
  exit 1
fi

mkdir -p "${PUBLISH_DIR}"

FIRST_FRAME="$(find "${LATEST_CAPTURE}" -maxdepth 1 -name 'frame_*.png' | sort | head -n 1)"
LAST_FRAME="$(find "${LATEST_CAPTURE}" -maxdepth 1 -name 'frame_*.png' | sort | tail -n 1)"

if [[ -n "${FIRST_FRAME}" ]]; then
  cp "${FIRST_FRAME}" "${PUBLISH_DIR}/latest.png"
  cp "${LAST_FRAME}" "${PUBLISH_DIR}/latest-frame.png"
fi

if [[ -f "${LATEST_CAPTURE}/demo.mp4" ]]; then
  cp "${LATEST_CAPTURE}/demo.mp4" "${PUBLISH_DIR}/latest.mp4"
fi

cp "${LATEST_CAPTURE}/meta.txt" "${PUBLISH_DIR}/meta.txt" 2>/dev/null || true

cat > "${PUBLISH_DIR}/README.txt" <<EOF
Captura generada desde: ${LATEST_CAPTURE}
Para el agente: leer ${PUBLISH_DIR}/latest.png y mostrarla al usuario.
Para PR: <img src="${PUBLISH_DIR}/latest.png" alt="Gameplay capture" />
Video: ${PUBLISH_DIR}/latest.mp4
EOF

echo "Publicado en: ${PUBLISH_DIR}"
ls -la "${PUBLISH_DIR}"
