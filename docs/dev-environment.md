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

## Estructura de herramientas en el repo

```
scripts/
  verify-godot.sh      # entrada única verificación
.tools/                # gitignored — binario Godot descargado
code/tests/
  run_tests.gd         # runner headless
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
