# Estructura del proyecto (Godot)

Documento de referencia para la organización del código en `code/`. Describe la **estructura objetivo** del repositorio: qué va en cada carpeta, qué convenciones seguir y qué está implementado hoy.

## Principios

1. **Sistemas reutilizables** en `systems/` — reglas, contratos y lógica sin acoplar a una escena concreta.
2. **Actores** en `actors/` — scripts y composición de entidades jugables o NPC (escenas en `scenes/actors/`).
3. **Contratos compartidos** en `core/` — tipos de dominio (comandos, intents) que varios sistemas consumen.
4. **Escenas** en `scenes/` — solo composición de nodos; la lógica vive en scripts referenciados desde `actors/` o `systems/`.
5. **InputMap solo en el borde** — `Input.*` y nombres de acciones de Godot se leen únicamente en `systems/input/`; el resto del juego trabaja con **comandos abstractos**.

## Árbol objetivo

```
code/
├── project.godot
├── core/
│   └── commands/
│       └── game_command.gd
├── systems/
│   ├── input/
│   │   └── player_input_reader.gd
│   ├── simulation/
│   │   ├── simulation_clock.gd
│   │   └── temporal_locks.gd
│   ├── combat/
│   │   ├── ability_executor.gd
│   │   └── ability_use_result.gd
│   ├── debug/
│   │   └── combat_debug_overlay.gd
│   └── movement/                  # (futuro)
├── actors/
│   ├── components/
│   │   └── actor_resources.gd
│   └── player/
│       ├── player.gd
│       └── player_combat.gd
├── content/
│   └── abilities/
│       ├── ability_definition.gd
│       ├── ability_loadout.gd
│       ├── pirate_default_loadout.tres
│       └── resources/*.tres
├── scenes/
│   ├── main.tscn
│   ├── actors/player.tscn
│   └── levels/prototype_arena.tscn
├── tests/
│   └── run_tests.gd
└── ui/                            # (futuro)
```

## Convenciones de nombres

| Elemento | Convención | Ejemplo |
|----------|------------|---------|
| Carpetas | `snake_case`, plural cuando agrupa varios | `systems/input/` |
| Scripts GDScript | `snake_case.gd` | `player_input_reader.gd` |
| `class_name` | PascalCase | `GameCommand`, `AbilityExecutor` |
| Escenas | `snake_case.tscn` | `player.tscn` |
| Acciones InputMap | `snake_case` | `cast_slot_2`, `primary_action` |
| Comandos de dominio | `GameCommand.Type` | `CAST_SLOT_PRESSED`, `MOVE_INTENT` |
| IDs de habilidad | `snake_case` StringName | `sabre_slash`, `pistol_shot` |

## Flujo: input → combate (MVP)

```
InputMap
    → PlayerInputReader → GameCommand[]
    → Player (movimiento + reenvío)
    → PlayerCombat → AbilityExecutor
            ├ SimulationClock.now
            ├ TemporalLocks (GCD + CD por ability_id)
            └ ActorResources (vigor)
```

Detalle de habilidades: [`mvp-abilities.md`](mvp-abilities.md).

## Estado de implementación

| Ruta | Estado | Notas |
|------|--------|-------|
| `core/commands/game_command.gd` | Hecho | `MOVE_INTENT`, `CAST_SLOT_PRESSED` |
| `systems/input/` | Hecho | Slots 1–3 |
| `systems/simulation/` | Hecho | Reloj + GCD + CD |
| `systems/combat/` | Hecho | Validación y aplicación MVP |
| `systems/debug/combat_debug_overlay.gd` | Hecho | Vigor, GCD, CDs |
| `actors/components/actor_resources.gd` | Hecho | Vigor + regen |
| `actors/player/player_combat.gd` | Hecho | Orquesta loadout |
| `content/abilities/` | Hecho | 3 habilidades pirata `.tres` |
| `tests/run_tests.gd` | Hecho | 4 pruebas headless |
| `systems/movement/` | Planificado | Knockback, root |
| Cast time / canales | Planificado | `cast_time > 0` en datos |
| `ui/` barras pulidas | Planificado | Señales desde combate |

## Verificación

Desde la raíz del repo: `./scripts/verify-godot.sh` — ver [`dev-environment.md`](dev-environment.md).

## Cómo añadir algo nuevo

1. Nombrar el **sistema** y su carpeta bajo `systems/` o dato bajo `content/`.
2. Tipos compartidos en `core/`; definiciones de habilidad como `Resource` en `content/`.
3. Actualizar esta tabla y `mvp-abilities.md` si cambia el contrato de combate.

## Relación con el resto del repo

- [`AGENTS.md`](../AGENTS.md) — visión por sistemas
- [`docs/agents/action-combat.md`](agents/action-combat.md) — combate por acciones
- [`docs/dev-environment.md`](dev-environment.md) — setup local y agente
