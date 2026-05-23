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
├── core/                          # Contratos y tipos de dominio (sin nodos de escena)
│   └── commands/
│       └── game_command.gd        # Comandos abstractos (movimiento, acción principal, …)
├── systems/                       # Subsistemas con frontera clara
│   ├── input/
│   │   └── player_input_reader.gd # InputMap → Array[GameCommand] (único lugar con Input.*)
│   ├── movement/                  # (futuro) intents, knockback, bloqueos de movimiento
│   ├── simulation/                # (futuro) tiempo de simulación, cooldowns, GCD
│   ├── combat/                    # (futuro) validación y resolución de acciones
│   └── debug/                     # (futuro) overlay y telemetría
├── actors/                        # Lógica de entidades (scripts; no .tscn obligatorio aquí)
│   └── player/
│       └── player.gd              # CharacterBody2D: aplica comandos (movimiento + acción)
├── scenes/
│   ├── main.tscn                  # Punto de entrada: nivel + jugador
│   ├── actors/
│   │   └── player.tscn
│   └── levels/
│       └── prototype_arena.tscn   # Entornos de prueba / MVP
├── content/                       # (futuro) datos: habilidades, enemigos, diálogos (.tres, .json)
├── ui/                            # (futuro) HUD y menús (Control; señales hacia dominio)
└── autoload/                      # (futuro) servicios globales acotados (p. ej. GameLog)
```

## Convenciones de nombres

| Elemento | Convención | Ejemplo |
|----------|------------|---------|
| Carpetas | `snake_case`, plural cuando agrupa varios | `systems/input/` |
| Scripts GDScript | `snake_case.gd` | `player_input_reader.gd` |
| `class_name` | PascalCase, alineado al rol | `GameCommand`, `Player` |
| Escenas | `snake_case.tscn` | `player.tscn`, `prototype_arena.tscn` |
| Acciones InputMap | `snake_case`, verbo o dirección | `move_left`, `primary_action` |
| Comandos de dominio | tipos en `GameCommand.Type` | `MOVE_INTENT`, `PRIMARY_ACTION_PRESSED` |

## Flujo de input (issue #5)

```
InputMap (project.godot)
        ↓  solo en PlayerInputReader
   GameCommand[]  (core/commands)
        ↓  poll por tick de física
      Player  (actors/player)
        ├→ velocidad / move_and_slide()
        └→ acción principal (hoy: log debug; luego combate)
```

## Estado de implementación

| Ruta | Estado | Notas |
|------|--------|-------|
| `core/commands/game_command.gd` | Hecho | Comandos abstractos mínimos |
| `systems/input/player_input_reader.gd` | Hecho | Lee acciones WASD/flechas + Space |
| `actors/player/player.gd` | Hecho | Movimiento 2D + disparo de acción principal |
| `scenes/actors/player.tscn` | Hecho | `CharacterBody2D` + placeholder visual |
| `scenes/levels/prototype_arena.tscn` | Hecho | Suelo y bordes con colisión |
| `systems/movement/`, `simulation/`, `combat/` | Planificado | Siguientes incrementos por sistema |
| `content/`, `ui/`, `autoload/` | Planificado | Cuando exista estado de actor y combate base |

## Cómo añadir algo nuevo

1. Nombrar el **sistema** (una frase) y decidir si es carpeta nueva bajo `systems/` o extensión de una existente.
2. Si hace falta un tipo compartido (comando, intent, evento), añadirlo en `core/` — no en scripts de escena.
3. La escena instancia nodos y asigna scripts; no duplicar reglas de dominio en `.tscn`.
4. Actualizar la tabla **Estado de implementación** de este documento en el mismo PR.

## Relación con el resto del repo

- Visión de sistemas y progresión: [`AGENTS.md`](../AGENTS.md)
- Godot idiomático: [`docs/agents/godot-engine.md`](agents/godot-engine.md)
- Movimiento (futuro 3D): [`docs/agents/movement-navigation.md`](agents/movement-navigation.md)
