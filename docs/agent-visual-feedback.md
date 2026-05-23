# Feedback visual para el agente (Cursor Cloud)

Guía para que el **agente** pueda mostrarte **imagen o video** después de cambios visuales en el juego — sin depender de que tú abras Godot.

## Qué NO es esto

| Concepto | Qué sería | Qué usamos nosotros |
|----------|-----------|---------------------|
| **Computer Use** (uso del ordenador) | El agente controla un escritorio real: abre Godot, mueve el ratón, graba la ventana como un humano. | **No** está configurado en este repo. |
| **verify-godot.sh** | Tests headless, sin imagen. | Solo validación automática. |
| **capture-gameplay.sh** | Godot en display virtual (Xvfb), demo script, PNG + MP4. | **Sí** — base del flujo visual del agente. |

El enfoque del repo es **reproducible y barato**: un demo automatizado que siempre hace lo mismo (mover + 3 habilidades), no una sesión libre de juego.

## Qué SÍ puede hacer el agente hoy

1. Ejecutar `./scripts/publish-visual-artifacts.sh` (importa, captura, publica).
2. Copiar salida a `/opt/cursor/artifacts/visual/` (ruta que Cursor puede enlazar en PRs).
3. **Mostrarte una imagen en el chat** leyendo `latest.png` con la herramienta de lectura del agente (el cliente suele renderizarla).
4. **En el PR**, incrustar imagen o video con rutas bajo `/opt/cursor/artifacts/...` (el bot de PR de Cursor puede subirlas).

## Qué pedirle al agente en el chat

Ejemplos útiles:

- *"Después del cambio, ejecutá publish-visual-artifacts y mostráme el screenshot."*
- *"Cambio visual en el jugador — capturá demo y adjuntá el frame en el PR."*

Regla interna del repo (para el agente): ver sección **Feedback visual** en [`AGENTS.md`](../AGENTS.md).

## Requisitos del entorno (Cloud Agent / CI)

En la VM del agente hace falta:

- `xvfb-run` (pantalla virtual Linux)
- `ffmpeg` (opcional, para `demo.mp4`)
- Red para descargar Godot la primera vez (`verify-godot.sh`)

En tu **máquina local**, con monitor, también funciona `capture-gameplay.sh` sin Xvfb.

## Limitaciones honestas

- El video es un **demo fijo**, no demuestra interacción que no esté en `demo_playback.gd`.
- El agente **no** “juega” libremente; amplía el demo si necesitás otra secuencia.
- El video en el hilo del chat puede no reproducirse en todos los clientes; la **imagen** (`latest.png`) es lo más fiable.
- **Computer Use** (si lo activás en Cursor en otro modo/producto) sería complementario: más flexible, menos reproducible.

## Archivos clave

```
scripts/capture-gameplay.sh          # genera artifacts/capture-*/
scripts/publish-visual-artifacts.sh  # captura + copia a /opt/cursor/artifacts/visual/
code/tests/demo_playback.gd          # secuencia automatizada
```

## Ampliar el demo

Si un cambio visual requiere otra prueba (p. ej. menú, enemigo), editar `code/tests/demo_playback.gd` en la misma PR que el cambio visual.
