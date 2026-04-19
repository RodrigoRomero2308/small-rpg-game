# Agentes modulares (invocación bajo demanda)

Estos archivos son **roles opcionales**. No sustituyen a [`AGENTS.md`](../../AGENTS.md) del repositorio; lo **complementan** cuando tú (o un coordinador) los enlazás o copiás al chat.

| Agente | Archivo | Invocar cuando… |
|--------|---------|------------------|
| Coordinador | [`coordinator.md`](coordinator.md) | Hay varios frentes y querés un orden, criterios de corte y anti-scope creep. |
| Godot / motor | [`godot-engine.md`](godot-engine.md) | Estructura de escenas, física, señales, recursos, importación; buenas prácticas Godot 4. |
| Dirección creativa | [`creative-director.md`](creative-director.md) | Pilares del juego, tono, priorización fuerte, decir “no”. |
| Narrativa | [`narrative-story.md`](narrative-story.md) | Arcos, personajes, diálogos; enlace con datos y triggers. |
| Simulación tiempo real | [`realtime-simulation.md`](realtime-simulation.md) | Tick, timestep, orden de sistemas, autoridad de estado. |
| Movimiento y navegación | [`movement-navigation.md`](movement-navigation.md) | Desplazamiento, colisión, pathfinding, lectura del espacio. |
| Combate por acciones | [`action-combat.md`](action-combat.md) | Habilidades, GCD, casts, interrupciones, objetivos, daño. |
| Personaje y progresión | [`character-progression.md`](character-progression.md) | Stats, talentos, niveles, curvas, roles. |
| Inventario y equipo | [`inventory-equipment.md`](inventory-equipment.md) | Objetos, slots, stats derivadas, uso/consumo. |
| Mundo y zonas | [`world-zones.md`](world-zones.md) | Zonas, instancias, spawn, fases del mundo. |
| IA y encuentros | [`ai-encounters.md`](ai-encounters.md) | Enemigos, agro, patrones, composición de pulls. |
| Misiones y contenido | [`quests-content.md`](quests-content.md) | Quests, tablas, condiciones, recompensas como datos. |
| UI y HUD | [`ui-hud.md`](ui-hud.md) | Barras, cooldowns, tooltips, flujos; separación modelo/vista. |
| Multijugador / réplica | [`multiplayer-replication.md`](multiplayer-replication.md) | Cliente-servidor, predicción, reconciliación (si aplica). |
| QA y telemetría | [`qa-telemetry.md`](qa-telemetry.md) | Casos borde, repro, logs, pruebas de regresión. |

**Uso sugerido en Cursor:** `@docs/agents/<archivo>.md` junto con tu pedido, o pegar el bloque “Mandato” del rol que necesites.

**Assets externos:** ver [`docs/third-party-assets.md`](../third-party-assets.md).
