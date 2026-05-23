#!/usr/bin/env bash
# Verificación headless del proyecto Godot (import + smoke + tests).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODE_DIR="${ROOT}/code"
TOOLS_DIR="${ROOT}/.tools/godot"
GODOT_VERSION="${GODOT_VERSION:-4.4.1}"
ARCHIVE="Godot_v${GODOT_VERSION}-stable_linux.x86_64"
URL="https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/${ARCHIVE}.zip"

resolve_godot_bin() {
	if [[ -n "${GODOT_BIN:-}" && -x "${GODOT_BIN}" ]]; then
		echo "${GODOT_BIN}"
		return
	fi
	local candidate
	candidate="$(find "${TOOLS_DIR}" -maxdepth 1 -type f -name 'Godot_*_linux.x86_64' 2>/dev/null | head -n 1)"
	if [[ -n "${candidate}" && -x "${candidate}" ]]; then
		echo "${candidate}"
		return
	fi
	echo ""
}

install_godot() {
	mkdir -p "${TOOLS_DIR}"
	local zip="${TOOLS_DIR}/${ARCHIVE}.zip"
	if [[ ! -f "${zip}" ]]; then
		echo "Descargando Godot ${GODOT_VERSION}..."
		curl -fsSL "${URL}" -o "${zip}"
	fi
	unzip -qo "${zip}" -d "${TOOLS_DIR}"
}

GODOT="$(resolve_godot_bin)"
if [[ -z "${GODOT}" ]]; then
	install_godot
	GODOT="$(resolve_godot_bin)"
fi

if [[ -z "${GODOT}" ]]; then
	echo "No se encontró binario de Godot. Definí GODOT_BIN." >&2
	exit 1
fi

echo "Usando: ${GODOT}"
echo "Importando proyecto..."
"${GODOT}" --headless --path "${CODE_DIR}" --import

echo "Smoke: escena principal..."
"${GODOT}" --headless --path "${CODE_DIR}" --quit-after 2

echo "Tests unitarios..."
"${GODOT}" --headless --path "${CODE_DIR}" -s res://tests/run_tests.gd

echo "verify-godot: OK"
