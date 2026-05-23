#!/usr/bin/env bash
# Genera dos capturas: gameplay (escena) y log (eventos en pantalla).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBLISH_DIR="${CURSOR_ARTIFACTS_DIR:-/opt/cursor/artifacts/visual}"
TS="$(date -u +"%Y%m%dT%H%M%SZ")"

"${ROOT}/scripts/verify-godot.sh" >/dev/null

_run_capture() {
	local mode="$1"
	local out_dir="${ROOT}/artifacts/capture-${mode}-${TS}"
	export OVERLAY_MODE="${mode}"
	export CAPTURE_DIR="${out_dir}"
	export CAPTURE_SECONDS="${CAPTURE_SECONDS:-14}"
	"${ROOT}/scripts/capture-gameplay.sh" >&2
	printf '%s' "${out_dir}"
}

echo "=== Captura gameplay (escena + HUD) ==="
GAMEPLAY_DIR="$(_run_capture gameplay)"
echo ""

echo "=== Captura log (mismo demo, overlay de log) ==="
LOG_DIR="$(_run_capture log)"
echo ""

mkdir -p "${PUBLISH_DIR}"

copy_capture() {
	local src_dir="$1"
	local prefix="$2"
	local mid_frame
	mid_frame="$(find "${src_dir}" -maxdepth 1 -name 'frame_*.png' | sort | sed -n '40p')"
	local last_frame
	last_frame="$(find "${src_dir}" -maxdepth 1 -name 'frame_*.png' | sort | tail -n 1)"
	if [[ -n "${mid_frame}" ]]; then
		cp "${mid_frame}" "${PUBLISH_DIR}/${prefix}-frame.png"
	fi
	if [[ -n "${last_frame}" ]]; then
		cp "${last_frame}" "${PUBLISH_DIR}/${prefix}-frame-end.png"
	fi
	if [[ -f "${src_dir}/demo.mp4" ]]; then
		cp "${src_dir}/demo.mp4" "${PUBLISH_DIR}/${prefix}.mp4"
	fi
}

copy_capture "${GAMEPLAY_DIR}" "latest-gameplay"
copy_capture "${LOG_DIR}" "latest-log"

cp "${GAMEPLAY_DIR}/meta.txt" "${PUBLISH_DIR}/meta-gameplay.txt" 2>/dev/null || true
cp "${LOG_DIR}/meta.txt" "${PUBLISH_DIR}/meta-log.txt" 2>/dev/null || true

# Compatibilidad con rutas anteriores
if [[ -f "${PUBLISH_DIR}/latest-gameplay-frame-end.png" ]]; then
	cp "${PUBLISH_DIR}/latest-gameplay-frame-end.png" "${PUBLISH_DIR}/latest.png"
fi
if [[ -f "${PUBLISH_DIR}/latest-gameplay.mp4" ]]; then
	cp "${PUBLISH_DIR}/latest-gameplay.mp4" "${PUBLISH_DIR}/latest.mp4"
fi

cat > "${PUBLISH_DIR}/README.txt" <<EOF
Gameplay video: ${PUBLISH_DIR}/latest-gameplay.mp4
Log video: ${PUBLISH_DIR}/latest-log.mp4
Screenshot: ${PUBLISH_DIR}/latest-gameplay-frame-end.png
Log screenshot: ${PUBLISH_DIR}/latest-log-frame-end.png
EOF

echo "Publicado en: ${PUBLISH_DIR}"
ls -la "${PUBLISH_DIR}"
