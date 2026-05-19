# Plan de retoma (3 sesiones)

Objetivo general: recuperar foco, retomar ritmo de desarrollo en Godot 4.x y reforzar una base de sistemas reusable para combate en tiempo real por acciones.

Regla de oro para estas sesiones: una sola victoria clara por dia. Si se termina antes, se usa el tiempo restante para testear y documentar, no para abrir otro frente.

## Sesion 1 (45-60 min) - Reenganche y mapa del sistema

Objetivo: volver a tener contexto del proyecto y dejar definido un sistema minimo de tiempo/cadencia de acciones.

### Agenda sugerida
- 10 min: lectura guiada del repo (arquitectura actual y estado real).
- 15 min: definir contrato del sistema "tiempo de simulacion + cooldown/GCD".
- 20 min: implementar un MVP chico.
- 10 min: smoke test y bitacora.

### Entregable concreto
- Existe un sistema basico que permite:
  - registrar `now` de simulacion,
  - iniciar cooldown global o por accion,
  - consultar si una accion esta disponible.
- El criterio de cierre es observable en debug/logs.

### Prompt sugerido para Cursor
> "Lee el proyecto y proponeme un MVP del sistema de tiempo + cooldown/GCD en Godot 4.x, con contrato (entradas/salidas/estado), invariantes y un orden de implementacion en 3 pasos chicos."

### Criterio de "listo"
- Se puede comprobar en ejecucion que una accion:
  - entra en cooldown al usarse,
  - no puede relanzarse antes de tiempo,
  - vuelve a estar disponible al vencer la duracion.

## Sesion 2 (45-60 min) - Input abstracto y activacion de accion

Objetivo: conectar el sistema de tiempo/cooldown con comandos de input abstractos (sin acoplar teclas a logica de dominio).

### Agenda sugerida
- 10 min: revisar Session 1 y limpiar deuda tecnica minima.
- 20 min: capa de comando abstracto (ej. `cast_slot_1`, `cancel_cast`).
- 20 min: disparo de accion con validaciones basicas.
- 10 min: test rapido + bitacora.

### Entregable concreto
- Un comando de input abstracto dispara una accion.
- El sistema valida disponibilidad temporal (GCD/cooldown) antes de ejecutar.
- Se evita acople fuerte entre InputMap y logica central.

### Prompt sugerido para Cursor
> "Quiero mapear input a comandos abstractos en Godot 4 y conectar eso al uso de habilidad con cooldown. Mantenelo simple, testeable y sin hardcodear teclas dentro del dominio."

### Criterio de "listo"
- Al presionar input configurado:
  - si esta disponible, la accion se ejecuta y consume su lockout temporal,
  - si no esta disponible, no se ejecuta y queda traza clara (debug/log).

## Sesion 3 (45-60 min) - Estado del actor + telemetria minima

Objetivo: cerrar un bucle de combate temprano con estado del actor y observabilidad.

### Agenda sugerida
- 10 min: repaso de invariantes actuales.
- 20 min: sumar estado minimo del actor (vida + un recurso).
- 20 min: integrar consumo/costo de accion y output de debug.
- 10 min: checklist de estabilidad + siguiente paso.

### Entregable concreto
- El actor tiene estado base (vida + recurso).
- Una accion valida aplica costo y respeta bloqueos temporales.
- Existen trazas/overlay de debug para inspeccionar el sistema.

### Prompt sugerido para Cursor
> "Agreguemos estado minimo del actor (vida y recurso), conectalo con la accion del slot 1 y dejame telemetria simple para depurar: que se uso, cuando entro/salio cooldown, y estado final."

### Criterio de "listo"
- No se consume recurso si la accion no se ejecuta.
- Si la accion se ejecuta, costo y cooldown quedan consistentes.
- Se puede leer rapidamente en debug por que una accion fallo o salio bien.

## Mini rutina de inicio/cierre (para no dispersarte)

### Inicio (3-5 min)
- Definir una meta unica de sesion.
- Escribir "no voy a tocar X hoy" (scope guard).
- Pedirle a Cursor un plan de 3 pasos maximo.

### Cierre (3-5 min)
- Registrar:
  - que quedo funcionando,
  - que quedo a medias,
  - primer paso exacto para la proxima sesion.

## Backlog posterior (no tocar ahora)

- Validaciones espaciales de combate (rango, LoS, facing).
- Cast time/canalizaciones y cancelaciones mas completas.
- UI de barra de habilidades desacoplada via seniales.
- Data-driven de habilidades con `Resource`.

## Nota de uso con Cursor

Cuando te notes disperso, usa este prompt corto:

> "Estoy disperso. Dame solo el siguiente paso de 15 minutos para avanzar el sistema actual, con criterio de cierre binario."
