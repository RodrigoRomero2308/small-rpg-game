# Entorno de desarrollo y verificación

Guía para probar el juego en local y para que un **agente en la nube** (sin editor gráfico) pueda validar el proyecto.

## Requisitos

| Herramienta | Versión recomendada | Uso |
|-------------|---------------------|-----|
| Godot | **4.4+** (proyecto apunta a 4.6) | Editor, jugar, import |
| Git | cualquiera | Clonar repo |
| Bash + curl + unzip | — | Script de verificación headless |

## Setup local (jugador humano)

1. Clonar el repositorio.
2. Abrir la carpeta **`code/`** en Godot (Project → Import → elegir `code/project.godot`).
3. Dejar que termine la importación (genera `code/.godot/`, está en `.gitignore`).
4. **F5** — escena principal `res://scenes/main.tscn`.
5. Controles: WASD/flechas, **Space** o clic = slot 1, **2** = slot 2, **3** = slot 3.
6. Revisar overlay arriba a la izquierda (vigor, GCD, CDs) y la consola de Godot (acciones ejecutadas o rechazadas).

## Verificación automática (agente / CI)

Desde la **raíz del repo**:

```bash
./scripts/verify-godot.sh
```

El script:

1. Descarga Godot **4.4.1** Linux x86_64 si no existe en `.tools/godot/`.
2. Ejecuta `--import` sobre `code/`.
3. Ejecuta `--headless` unos segundos (carga escena principal).
4. Ejecuta tests GDScript en `code/tests/run_tests.gd`.

Código de salida `0` = OK; distinto de `0` = fallo (parse, carga o tests).

### Variables opcionales

| Variable | Default | Descripción |
|----------|---------|-------------|
| `GODOT_VERSION` | `4.4.1` | Versión a descargar |
| `GODOT_BIN` | `.tools/godot/Godot_*_linux.x86_64` | Binario ya instalado (salta descarga) |

### Si ya tenés Godot en PATH

```bash
export GODOT_BIN="$(which godot4 || which godot)"
./scripts/verify-godot.sh
```

## Qué puede probar el agente sin pantalla

- Proyecto importa sin errores.
- Scripts con `class_name` compilan.
- Tests unitarios de `TemporalLocks`, `ActorResources`, `AbilityExecutor`.
- Arranque headless de la escena principal (sin assert de gameplay visual).

No sustituye una pasada manual de “¿se siente bien el GCD?”; eso sigue siendo en editor con overlay.

## Captura de video / screenshots (agente o CI)

`./scripts/verify-godot.sh` **no graba video**: corre `--headless` sin ventana ni frames visibles.

Para **prueba visual reproducible** (PNG + MP4):

```bash
./scripts/verify-godot.sh          # primero: Godot en .tools/
./scripts/capture-gameplay.sh
```

Salida en `artifacts/capture-<timestamp>/`:

- `frame_0000.png`, `frame_0001.png`, …
- `demo.mp4` (si hay `ffmpeg`)
- `meta.txt` (conteo de frames, duración)

### Cómo funciona

| Pieza | Rol |
|-------|-----|
| `xvfb-run` | Display virtual 640×360 en servidores sin pantalla |
| `demo_playback.gd` | Carga `main.tscn`, simula movimiento + slots 1–3, guarda frames |
| `ffmpeg` | Monta PNG → `demo.mp4` |

Variables opcionales:

| Variable | Default | Descripción |
|----------|---------|-------------|
| `CAPTURE_DIR` | `artifacts/capture-<utc>` | Carpeta de salida |
| `CAPTURE_SECONDS` | `8` | Duración del demo |
| `CAPTURE_FPS` | `15` | Frames por segundo |

En **tu PC con monitor**, si ya tenés `DISPLAY`, el script usa Godot sin Xvfb.

### ¿Puede el agente en la nube grabar?

Sí, si en el entorno hay **Xvfb** y **ffmpeg** (este repo los usa en Linux). El agente debe ejecutar:

```bash
./scripts/capture-gameplay.sh
```

y adjuntar `artifacts/capture-*/demo.mp4` o los PNG al informe del PR. No sustituye jugar a mano, pero documenta regresiones visuales básicas.

### Grabación manual (humano)

- **OBS / QuickTime / Game Bar**: grabar ventana del juego (F5 en Godot).
- **Godot Movie Maker** (editor): útil para trailers; no está automatizado en este repo aún.

## Estructura de herramientas en el repo

```
scripts/
  verify-godot.sh       # tests + smoke headless (sin video)
  capture-gameplay.sh   # demo + PNG + MP4
.tools/                 # gitignored — binario Godot
artifacts/              # gitignored — capturas
code/tests/
  run_tests.gd          # tests unitarios
  demo_playback.gd      # demo para captura
```

## Solución de problemas

| Síntoma | Acción |
|---------|--------|
| `Could not find type "GameCommand"` al primer run | Ejecutar `./scripts/verify-godot.sh` o abrir el proyecto en el editor una vez (genera caché de clases). |
| Sin display en Linux headless | Normal; usar script de verificación, no F5 en servidor. |
| Rama sin issue #5 | Este sistema asume movimiento + input; mergear PR del issue #5 o la rama `cursor/issue-5-movement-input-35c7`. |

## Relacionado

- Estructura de carpetas: [`project-structure.md`](project-structure.md)
- Tabla de habilidades: [`mvp-abilities.md`](mvp-abilities.md)
