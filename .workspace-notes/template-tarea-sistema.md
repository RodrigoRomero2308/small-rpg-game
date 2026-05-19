# Template de tarea (enfoque por sistema)

Usar este template para cada tarea importante del juego. Copiar y pegar en un nuevo bloque por tarea.

---

## Titulo
`[Sistema] Nombre corto de la tarea`

## Tipo de tarea
- [ ] Sistema nuevo
- [ ] Mejora de sistema
- [ ] Bug
- [ ] Refactor acotado
- [ ] Contenido/Datos
- [ ] Herramientas/Debug

## Estado
- [ ] Backlog
- [ ] Ready
- [ ] In progress
- [ ] Review
- [ ] Done
- [ ] Bloqueada

## Sistema
Nombre:

Que hace:

Que NO hace:

## Objetivo de esta tarea
(1-2 frases, resultado concreto en juego o en debug)

## MVP (minimo validable)
- Comportamiento minimo 1:
- Comportamiento minimo 2:
- Comportamiento minimo 3:

## Contrato del sistema
Entradas:
- 

Salidas:
- 

Estado interno:
- 

Invariantes (nunca debe pasar):
- 

## Dependencias reales
- Sistema/Modulo:
- Datos/Recursos:
- Escena/Nodo:

## Criterio de cierre (Definition of Done)
- [ ] Jugable o verificable en ejecucion
- [ ] Sin acoples innecesarios entre UI y dominio
- [ ] Logs/debug suficientes para entender fallos
- [ ] Caso borde principal cubierto

## Test plan manual (3-5 pasos)
1.
2.
3.

## Riesgos
- Riesgo 1:
- Riesgo 2:

## Fuera de alcance (por ahora)
- 

## Notas de implementacion
- 

## Resultado final
Que quedo funcionando:

Que quedo pendiente:

Primer paso siguiente:

---

## Ejemplo corto

Titulo: `[Combate] Cooldown global basico`

Tipo: Sistema nuevo  
Estado: Ready

Sistema: Cadencia temporal de acciones (GCD)  
Hace: bloquea uso de nuevas acciones por una ventana temporal tras una activacion valida.  
No hace: cast time, canales, validaciones espaciales.

Objetivo: impedir spam de acciones y exponer trazas de cuando inicia/finaliza el GCD.

MVP:
- iniciar GCD al activar accion valida,
- negar acciones mientras el GCD esta activo,
- habilitar acciones al vencer el tiempo.
