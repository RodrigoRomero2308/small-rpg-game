# Guía del agente: RPG pequeño, enfoque por sistemas

Este repositorio explora un **RPG pequeño** con mentalidad de **ingeniería de sistemas**, no de lista de features. Cualquier chat de Cursor en este repo debe alinear propuestas con esta visión.

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

Orden orientativo; no es dogma, pero **respeta “poco a la vez”**:

1. **Bucle de juego** — tick/update, inicio/fin de frame o turno, capa mínima de “mundo” o escena.
2. **Entidades y ciclo de vida** — crear, actualizar, destruir; identidad estable (IDs).
3. **Representación de estado** — dónde vive la verdad (modelo), separada de presentación si aplica.
4. **Input** — acciones abstractas (mover, confirmar), no teclas pegadas a lógica de dominio.
5. **Movimiento o posición** — grid o continuo; colisiones solo cuando el movimiento exista.
6. **Turnos o tiempo** — quién actúa y cuándo; orden determinista.
7. **Acciones / intención** — una cola o resolución de acciones con reglas explícitas.
8. **Recursos del actor** — por ejemplo energía o vida, **un** recurso primero.
9. **Inventario o equipamiento** — después de que existan entidades y acciones coherentes.
10. **Contenido** (mapas, enemigos, objetos) — datos que **consumen** sistemas ya existentes.

Saltar niveles “porque es divertido” está bien solo si el **salto** se documenta como deuda consciente y el cambio sigue siendo pequeño.

## Anti-patrones (evitar)

- Tablero de Trello de features sin mapa de sistemas.
- “RPG completo” en el primer PR: menús, guardado, IA, loot y quests a la vez.
- Lógica duplicada en UI y en núcleo sin frontera clara.
- Nuevos tipos de entidad antes de tener **ciclo de vida** y **actualización** claros.
- “Ya lo arreglamos después” para fronteras entre sistemas — **la frontera es el diseño**.

## Brainstorming técnico

Para ideas nuevas o rediseños, priorizar:

- **Invariantes** — qué nunca debe ocurrir (p. ej. dos acciones en el mismo slot ilegalmente).
- **Determinismo** — si importa para replay, tests o multijugador futuro.
- **Telemetría / depuración** — qué se puede loguear o inspeccionar con un sistema nuevo.
- **Pruebas** — qué caso mínimo prueba el sistema sin depender del resto del juego.

Si en el entorno está disponible la skill de brainstorming del usuario, **usarla** para trabajo creativo antes de codificar a lo grande.

## Idioma

Las respuestas al usuario deben seguir sus preferencias de idioma del momento (por defecto en este proyecto: **español**).
