# Habilidades MVP (pirata)

Borrador de diseño para validar el **sistema de tiempo + GCD + CD + recurso** antes de añadir enemigos, daño numérico o cast largos.

Recurso del capitán en esta fase: **vigor** (implementado como `energy` en código; renombrable cuando exista UI).

| Slot | ID | Nombre | Tecla (InputMap) | Tipo | Coste vigor | GCD global | CD propio | Rol en loop |
|------|-----|--------|------------------|------|-------------|------------|-----------|-------------|
| 1 | `sabre_slash` | Sablazo | Space / clic izq. (`primary_action` → slot 1) | Instantánea | 15 | 1,0 s | — | Golpe base, spam limitado por GCD |
| 2 | `pistol_shot` | Disparo de pistola | `2` | Instantánea | 25 | 1,0 s | 4,0 s | Burst a distancia; pacing medio |
| 3 | `plank_strike` | Golpe de tablón | `3` | Instantánea | 35 | 1,0 s | 8,0 s | Golpe fuerte; ventana de decisión |

## Reglas compartidas (MVP)

- **GCD global**: tras cualquier habilidad que lo respete, ninguna otra puede entrar hasta `now + 1.0 s` (salvo que en datos se marque `respects_gcd = false`; ninguna del MVP lo hace).
- **CD por habilidad**: solo bloquea **esa** habilidad; no sustituye al GCD.
- **Coste**: si no hay vigor suficiente, la acción **no se ejecuta** y **no** consume GCD ni CD.
- **Regeneración**: 8 vigor/s (para pruebas en arena; balance posterior).
- **Efecto de combate**: por ahora solo log + señal; el daño llegará con el sistema de resolución/enemigos.

## Orden de validación al probar

1. Sablazo varias veces seguidas → solo una cada ~1 s (GCD).
2. Disparo → esperar GCD → disparo otra vez antes de 4 s → rechazado (CD).
3. Tablón con poco vigor → rechazado (recurso); con vigor → entra CD 8 s.
4. Overlay de debug muestra vigor, GCD restante y CD por slot.

## Fuera de este MVP

- Cast time y canales (`cast_time > 0`).
- Objetivo enemigo, rango y LoS.
- Habilidades off-GCD.
- Barra de UI pulida (solo overlay de debug).

## Archivos de datos

Definiciones en `code/content/abilities/resources/` y loadout en `pirate_default_loadout.tres`.
