# Guía del agente: RPG pequeño, enfoque por sistemas

Este repositorio explora un **RPG pequeño** con mentalidad de **ingeniería de sistemas**, no de lista de features. Cualquier chat de Cursor en este repo debe alinear propuestas con esta visión.

**Motor:** el desarrollo se orienta a **Godot 4.x**. Las recomendaciones de implementación deben ser **idiomáticas** (escenas/nodos, `_physics_process` vs `_process`, señales, `Resource`, `InputMap`, etc.). Detalle en [`docs/agents/godot-engine.md`](docs/agents/godot-engine.md). Referencia de **assets de terceros** (CC0/MIT y enlaces): [`docs/third-party-assets.md`](docs/third-party-assets.md).

**Combates y momentos a priori “tipo MMO” (referencia: WoW):** simulación en **tiempo real** donde el jugador lanza **acciones** (instantáneas, casteos, canales) con **cadencia** (GCD o equivalente), **cooldowns** y lectura del espacio. **No** es el marco por defecto el combate **por turnos**; si aparece algo por turnos, debe ser un **subsistema acotado** y explícito (p. ej. minijuego), no el supuesto del diseño.

## Roles de agente (invocación bajo demanda)

Las instrucciones detalladas por dominio viven en [`docs/agents/`](docs/agents/README.md). **No hace falta cargarlas todas:** invocá el rol que corresponda (o un **coordinador** que acote alcance) cuando trabajes esa parte del juego.

## Principio central

**Pensar en sistemas, no en features.** Una “feature” es lo que el jugador percibe; un **sistema** es la pieza reutilizable con reglas claras, datos, límites y puntos de integración. Antes de proponer “añadir X”, se nombra **qué sistema** lo sostiene y **qué contrato** (entradas, salidas, estado) expone.

## Cómo proponer cosas nuevas

1. **Nombrar el sistema** en una frase: qué hace y qué *no* hace.
2. **Definir el mínimo viable del sistema**: qué comportamiento basta para validarlo en juego o en pruebas.
3. **Listar dependencias reales** (otros sistemas o tipos de datos), no deseos futuros.
4. **Evitar bundling**: si la idea mezcla combate + inventario + diálogo en un mismo cambio, **separar** en sistemas y elegir **uno** para este paso.
5. **Criterio de cierre**: cómo sabremos que el sistema está “listo” para este incremento (jugable, testeable o observable en debug).

Si el usuario pide algo ambiguo, **reformular en términos de sistemas** y confirmar alcance antes de implementar.

## Progresión sugerida (de lo básico hacia afuera)

Orden orientativo para **tiempo real por acciones**; no es dogma, pero **respeta “poco a la vez”**:

1. **Bucle de juego** — tick/update por frame o timestep fijo, capa mínima de “mundo” o escena.
2. **Entidades y ciclo de vida** — crear, actualizar, destruir; identidad estable (IDs).
3. **Representación de estado** — dónde vive la verdad (modelo), separada de presentación si aplica.
4. **Input** — comandos abstractos (mover, usar habilidad en slot N, cancelar cast), no teclas pegadas a lógica de dominio.
5. **Movimiento o posición** — continuo o grid; colisiones cuando el movimiento exista; knockback/root después si aplica.
6. **Tiempo de simulación** — `now`, duraciones, timestamps de fin de efecto; orden de actualización de subsistemas **por tick**, no “rondas”.
7. **Combate por acciones** — validación (rango, LoS, facing), colas cortas o reglas de lockout, **GCD/cooldowns**, casts cancelables.
8. **Recursos del actor** — vida + **un** recurso de habilidad primero (maná, energía, enfado…); ampliar después.
9. **Inventario o equipamiento** — cuando el actor y el combate base ya tengan fronteras claras.
10. **Contenido** (mapas, enemigos, objetos, quests) — datos que **consumen** sistemas ya existentes.

Saltar niveles “porque es divertido” está bien solo si el **salto** se documenta como deuda consciente y el cambio sigue siendo pequeño.

## Anti-patrones (evitar)

- Tablero de Trello de features sin mapa de sistemas.
- “RPG completo” en el primer PR: menús, guardado, IA, loot y quests a la vez.
- Lógica duplicada en UI y en núcleo sin frontera clara.
- Nuevos tipos de entidad antes de tener **ciclo de vida** y **actualización** claros.
- “Ya lo arreglamos después” para fronteras entre sistemas — **la frontera es el diseño**.

## Brainstorming técnico

Para ideas nuevas o rediseños, priorizar:

- **Invariantes** — qué nunca debe ocurrir (p. ej. gastar recurso sin aplicar efecto, o aplicar efecto sin coste cuando el coste es obligatorio).
- **Determinismo** — si importa para replay, tests o multijugador futuro.
- **Telemetría / depuración** — qué se puede loguear o inspeccionar con un sistema nuevo.
- **Pruebas** — qué caso mínimo prueba el sistema sin depender del resto del juego.

Si en el entorno está disponible la skill de brainstorming del usuario, **usarla** para trabajo creativo antes de codificar a lo grande.

## Feedback visual (cambios en pantalla)

Cuando el usuario pida un **cambio visual** (sprites, UI, colores, escena, animación) o quiera **ver** el resultado:

1. Tras implementar y pasar `./scripts/verify-godot.sh`, ejecutar **`./scripts/publish-visual-artifacts.sh`**.
2. **Mostrar al usuario** la imagen leyendo `/opt/cursor/artifacts/visual/latest.png` (herramienta Read).
3. En **PR**, incrustar esa ruta en markdown o HTML (`<img src="/opt/cursor/artifacts/visual/latest.png" />`).
4. Mencionar si existe `/opt/cursor/artifacts/visual/latest.mp4` (video del demo automatizado).

Esto **no** es Computer Use: no se controla el editor Godot con ratón. Es captura reproducible (Xvfb + demo script). Detalle: [`docs/agent-visual-feedback.md`](docs/agent-visual-feedback.md).

Si el cambio no se ve en el demo actual, ampliar `code/tests/demo_playback.gd` en la misma tarea.

## Idioma

Las respuestas al usuario deben seguir sus preferencias de idioma del momento (por defecto en este proyecto: **español**).
