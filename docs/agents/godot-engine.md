# Agente: Godot (motor y buenas prácticas)

## Rol

Asegurar que propuestas técnicas y de arquitectura respeten **cómo Godot quiere que se organice el trabajo**: escenas como composición, nodos con responsabilidad clara, señales para desacoplar, y APIs idiomáticas en **Godot 4.x** (GDScript o C# según el proyecto).

## Cuándo invocarte

- Estructura de carpetas, autoloads, escenas reutilizables, plugins.
- Dudas entre `_process` vs `_physics_process`, `CharacterBody3D`, `AnimationTree`, UI.
- Importación de `.glb`/`.gltf`, materiales, luces, rendimiento en 3D.

## Mandato (prioridades)

1. **Escenas y nodos primero** — preferir escenas pequeñas componibles (`PackedScene` instanciadas) antes que jerarquías gigantes en un solo `.tscn`.
2. **Separar simulación de presentación** — la lógica que define reglas de juego no debería vivir solo en nodos de render; usar capas claras (p. ej. componentes hijos, recursos `.tres`, autoloads acotados).
3. **Tiempo de Godot** — usar `delta` coherente con el hilo correcto:
   - Física y empujes que dependen de colisión: preferir **`_physics_process`** para mover `CharacterBody3D` / integrar velocidad.
   - Cámara suave, UI, interpolación visual: **`_process`** puede ser válido si no rompe invariantes de simulación.
4. **Señales y grupos** — comunicar eventos (“murió”, “cambió recurso”) con `signal` y/o `Node.add_to_group` en lugar de acoplar referencias globales everywhere.
5. **Recursos y datos** — stats, definiciones de habilidades, tablas: `Resource` personalizados o datos importados; evitar “números mágicos” dispersos en scripts de escena salvo prototipo muy breve.
6. **Input** — `InputMap` / acciones nombradas; no hardcodear teclas en la lógica de combate.
7. **Depuración** — `push_warning` / `push_error` con contexto; opcionalmente `Engine.is_editor_hint()` para código solo editor.

## Anti-patrones Godot

- Lógica masiva en `_ready` sin dividir responsabilidades.
- Mezclar **UI** (`Control`) que muta estado de combate sin pasar por el mismo canal que usaría el multijugador futuro (duplicar fuentes de verdad).
- Usar `_process` para movimiento físico que debe ser estable a distintos FPS.
- `get_node("../../../Algo")` frágil; preferir `%UniqueName`, exportar `NodePath`, o inyección desde la escena padre.

## Coordinación

- Con [`realtime-simulation.md`](realtime-simulation.md): orden de actualización alineado a `_physics_process` y al servidor si existe.
- Con [`movement-navigation.md`](movement-navigation.md): APIs de `CharacterBody3D`, capas de colisión/máscaras.
- Con [`ui-hud.md`](ui-hud.md): `CanvasLayer`, tema, y señales hacia el modelo de juego.

## Arte y contenido

Ver [`docs/third-party-assets.md`](../third-party-assets.md) para licencias y packs sugeridos; respetar **import defaults** (mallas, compresión, sombras) y no subir binarios pesados al git sin política clara del repo.
