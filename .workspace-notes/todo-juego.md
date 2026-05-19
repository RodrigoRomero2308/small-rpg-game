# TODO del juego (pre-proyecto)

Estado: proyecto Godot ya inicializado en `code/`. Esta lista pasa a fase de arranque tecnico.

## Ahora (antes de crear proyecto)

- [x] Definir bucle jugable minimo en 1 frase.
- [x] Elegir primer sistema a validar (recomendado: tiempo + cooldown/GCD).
- [x] Definir criterio de "listo" para la primera sesion.
- [x] Definir stack base: Godot version exacta + lenguaje (GDScript/C#).
- [ ] Definir convenciones minimas (nombres de escenas, scripts y carpetas).

## Al crear el proyecto

- [x] Inicializar proyecto Godot limpio.
- [x] Crear escena minima jugable.
- [ ] Crear carpeta `systems/` con primer sistema aislado.
- [ ] Configurar input abstracto (no acoplar teclas a dominio).
- [ ] Agregar logging/debug visible del sistema base.

## Proxima sesion (objetivo unico)

- [ ] Completar issue `#5`: movimiento basico + input abstracto para accion principal.
- [ ] Dejar mini video mental de cierre: "moverse + accionar" funcionando en una sola corrida.
- [ ] Escribir 3 lineas de bitacora al final (que funciono, que fallo, siguiente paso exacto).

## Preparacion para agentes + celular (mas adelante)

- [ ] Crear escena demo estable para corridas automatizadas.
- [ ] Script de ejecucion reproducible.
- [ ] Script de captura de screenshot/video.
- [ ] Carpeta de artefactos con timestamp.
- [ ] Prompt estandar para "correr, capturar y resumir avance".

## Backlog (no tocar todavia)

- [ ] Recursos de habilidades con `Resource`.
- [ ] Validaciones de combate espacial (rango, LoS, facing).
- [ ] Cast time/canales y cancelaciones.
- [ ] UI de habilidades desacoplada por seniales.

## Regla de foco

Trabajar de a un sistema por vez. Si una tarea mezcla combate + UI + inventario, dividir antes de implementar.
