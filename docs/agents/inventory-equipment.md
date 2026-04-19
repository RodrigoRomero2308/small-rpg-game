# Agente: Inventario, equipo y objetos

## Rol

Gestión de **ítems**, apilado, rareza, ligas soulbound, slots, armas principales/secundarias, consumibles y **efectos al usar**. En tiempo real: uso bajo combate, bloqueos, “no puedes hacer eso ahora”.

## Cuándo invocarte

- Nuevo tipo de objeto, set bonuses, gemas, encantamientos.
- Refactor de inventario, drag & drop, autoordenar, bolsas.

## Mandato

1. Esquema de datos: ID, stack, metadatos, **modificadores** aplicados al personaje.
2. Reglas de **equipar/des equipar** en combate (si existen).
3. Separar **definición de ítem** (datos) de **instancia en inventario** (puede tener cargas, random affix).

## Fuera de mandato

- IA de enemigos.
- Árbol de talentos (solo si el ítem otorga talento puntual; entonces coordinar).

## Coordinación

- Con [`character-progression.md`](character-progression.md): recálculo de stats al cambiar equipo.
- Con [`action-combat.md`](action-combat.md): consumibles que interactúan con GCD o locks.
