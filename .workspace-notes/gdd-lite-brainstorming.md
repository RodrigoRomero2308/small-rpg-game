# GDD Lite - Brainstorming inicial

Estado: borrador vivo.  
Objetivo: convertir ideas sueltas en una base clara para decidir los primeros pasos del juego.

Como usar este documento:
- Escribir respuestas cortas (1-5 lineas por punto).
- Evitar perfeccionismo: version 0 > version ideal.
- Marcar TODO cuando algo no este decidido.
- Revisar semanalmente y ajustar.

---

## 1) Identidad del juego (North Star)

### 1.1 Premisa en una frase
Completar:
> Este juego es sobre un pirata que perdio todo en un mundo maritimo hostil, donde el jugador busca venganza contra quienes destruyeron su barco.

### 1.2 Fantasia del jugador
Quiero que el jugador sienta que es:
- un capitan pirata marcado por la perdida, que navega entre la exploracion y una obsesion personal por ajustar cuentas.

### 1.3 Emocion principal
Quiero provocar principalmente:
- [ ] Tension
- [ ] Poder
- [x] Descubrimiento
- [ ] Supervivencia
- [ ] Calma
- [x] Otra: tragedia y obsesion por la venganza

### 1.4 Publico objetivo inicial
Este juego es para jugadores que disfrutan:
- accion y exploracion con sentido de riesgo, progreso tangible y una meta narrativa clara de venganza.

### 1.5 Fantasia principal/secundaria
- Principal: capitan cazador (perseguir objetivos concretos para acercarse a la venganza).
- Secundaria: superviviente obstinado (cada error cuesta y cada avance se gana).

---

## 2) Pilares de diseño (maximo 3)

Regla: si una idea no fortalece estos pilares, va al backlog.

### Pilar 1
Nombre: Mundo peligroso pero legible

Descripcion:
el jugador enfrenta riesgo constante, pero con senales claras para aprender y tomar decisiones.

Ejemplo concreto en gameplay:
enemigos, zonas o eventos comunican amenaza con feedback visible antes de castigar.

### Pilar 2
Nombre: Venganza como brujula

Descripcion:
las decisiones de avance, exploracion y combate siempre conectan con el objetivo de venganza.

Ejemplo concreto en gameplay:
cada objetivo importante aporta pistas, recursos o ventaja directa contra la faccion objetivo.

### Pilar 3 (opcional)
Nombre: Libertad pirata

Descripcion:
un mismo problema puede resolverse por rutas distintas (enfrentar, evadir, preparar mejor).

Ejemplo concreto en gameplay:
ante un encuentro hostil, el jugador puede pelear, escapar o rodear la zona para volver con mejor posicion.

---

## 3) No-objetivos (para mantener foco)

Que NO voy a hacer en esta etapa:
- 
- 
- 

Ejemplos tipicos:
- multijugador,
- sistema de quests complejo,
- crafting grande,
- cinematics.

---

## 4) Bucle central (Core Loop)

Completar como cadena simple:
> explorar zona de interes -> detectar amenaza u oportunidad -> resolver encuentro (pelear/evasir) -> recompensa util -> elegir siguiente objetivo de venganza

### Explicacion rapida (3-5 lineas)
- el jugador navega o recorre zonas buscando pistas y objetivos vinculados a su venganza.
- cada encuentro ofrece riesgo real, con opcion de combate directo o retirada tactica.
- superar encuentros entrega recursos, informacion o ventaja para el proximo objetivo.
- la progresion mantiene el foco narrativo: cada paso relevante acerca al jugador a su objetivo final.

### Señal de que el loop funciona
- en una sesion corta, el jugador puede completar al menos un ciclo entero y entender por que su decision lo acerco (o no) a la venganza.

---

## 5) MVP jugable (version minima que "se siente juego")

Unidad de progreso elegida (inicial):
- Principal: pistas del enemigo principal (A).
- Secundaria: mejoras del barco/equipo para habilitar nuevas opciones (C).

### 5.1 Alcance minimo
- [x] 1 mapa pequeno (fase siguiente, luego de flujo lineal)
- [x] 1 personaje jugable
- [x] 1 enemigo simple
- [x] 1 accion principal
- [x] movimiento basico
- [x] condicion de victoria/derrota simple

Formato inicial elegido:
- Fase 1 (MVP inmediato): secuencia lineal corta (tutorial + 1 objetivo + cierre).
- Fase 2 (transicion): mapa unico pequeno para rejugabilidad y exploracion libre acotada.

### 5.2 Definition of Done del MVP
El MVP esta listo cuando:
- el jugador puede recorrer una zona, encontrar una pista y vincularla con su objetivo de venganza.
- existe al menos una mejora simple de barco/equipo que cambie una decision de gameplay.
- hay un bucle completo jugable con condicion simple de exito/fracaso y feedback claro.

### 5.3 Fuera de alcance del MVP
- sistema de facciones complejo.
- economia/crafting profundo.
- narrativa ramificada extensa.

---

## 6) Base tecnica inicial (Godot)

### 6.1 Decisiones base
- Version Godot:
- Lenguaje (GDScript/C#):
- Plataforma objetivo inicial (PC, web, etc.):

### 6.2 Setup minimo
- [ ] crear proyecto Godot
- [ ] escena principal
- [ ] input base
- [ ] actor con movimiento
- [ ] debug/log visible

### 6.3 Regla tecnica
Primero sistemas base, despues contenido.

---

## 7) Sistemas iniciales (orden sugerido)

Completar con estado:
- [ ] Bucle/update
- [ ] Entidad actor + estado
- [ ] Input abstracto
- [ ] Tiempo de simulacion
- [ ] Acciones (cooldown/GCD minimo)
- [ ] Debug/telemetria

Notas:
- No abrir mas de 1 sistema nuevo por sesion.
- Si una tarea mezcla 3 sistemas, dividir.

---

## 8) Riesgos clave (top 3)

### Riesgo tecnico
Riesgo:

Como lo voy a validar pronto:

### Riesgo de diseno
Riesgo:
la venganza puede quedar solo en texto y no reflejarse en decisiones de juego.

Como lo voy a validar pronto:
cada recompensa del MVP debe impactar en la caceria del objetivo (pista o ventaja tangible).

### Riesgo de alcance
Riesgo:

Como lo voy a controlar:

---

## 9) Primeros baby steps (proximas 2 semanas)

Regla: tareas de 45-90 min, cierre binario (listo/no listo).

### Semana 1
1. Crear proyecto Godot 4.x y escena principal jugable (arranca/cierra sin errores).
2. Implementar movimiento basico + input abstracto minimo para accion principal.
3. Armar secuencia lineal corta: inicio, encuentro simple, cierre con pista narrativa.

### Semana 2
1. Integrar enemigo simple y resolucion de encuentro (pelea o evasion acotada).
2. Agregar recompensa util del ciclo (pista + mejora minima de barco/equipo).
3. Definir y probar transicion de flujo C -> A (lineal a mapa pequeno).

---

## 10) Registro de decisiones

Formato recomendado:
- Fecha:
- Decision:
- Motivo:
- Impacto:

Entradas:
- Fecha: 2026-04-26
  - Decision: arrancar implementacion con formato C (lineal corto) y preparar transicion a A (mapa pequeno).
  - Motivo: reducir dispersion y validar rapido un loop jugable completo.
  - Impacto: roadmap de issues en GitHub creado (#4 a #9) con foco en MVP por etapas.
- Fecha: 2026-04-26
  - Decision: considerar cierre de hito tecnico inicial al ejecutar escena principal en Godot.
  - Motivo: validar setup base antes de sumar sistemas de gameplay.
  - Impacto: siguiente tarea prioritaria pasa a input/movimiento (issue #5).

---

## 11) Prompt pack para brainstorming con Cursor

### Prompt 1 - aterrizar vision
> "Ayudame a convertir esta idea en una vision concreta de juego: premisa, fantasia del jugador, emocion principal y 3 pilares."

### Prompt 2 - recortar scope
> "Con esta vision, proponeme un MVP de 2-4 semanas con objetivos medibles y una lista clara de fuera de alcance."

### Prompt 3 - convertir vision en sistemas
> "Traduci este GDD Lite en sistemas tecnicos priorizados para Godot 4.x y proponeme los primeros 6 baby steps."

### Prompt 4 - evitar dispersion
> "Estoy disperso. Dado este GDD Lite, dame solo el siguiente paso de 15-30 minutos con criterio de cierre binario."

---

## 12) Versionado del documento

- Version actual: v0.2
- Ultima revision: proyecto inicial creado, escena principal ejecutando, roadmap de issues activo.
- Proxima revision: completar issue #5 y definir convenciones tecnicas minimas del proyecto.

Siguiente objetivo de calidad del documento:
- pasar de ideas sueltas a MVP cerrado con criterio de cierre claro.
