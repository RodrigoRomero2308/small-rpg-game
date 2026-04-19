# Assets de terceros (referencia)

Lista **orientativa** para prototipo 3D simple (pasto, árboles, decoración, personajes, armas). **Verificar siempre la licencia** en la página de descarga antes de publicar un build comercial.

## Entorno y props (estilo simple / CC0 frecuente)

- **Kenney — Nature Kit** — vegetación y elementos naturales estilizados.  
  https://kenney.nl/assets/nature-kit  
- **Kenney — Starter Kit 3D Platformer** — plantilla Godot con modelos CC0 y ejemplo de personaje; útil como referencia de proyecto.  
  https://github.com/KenneyNL/starter-kit-3d-platformer  
  También en la Asset Library: https://godotengine.org/asset-library/asset/2120  

## Personajes y animación (CC0 frecuente)

- **Quaternius — Universal Base Characters** — personajes base humanoid-friendly.  
  https://quaternius.com/packs/universalbasecharacters.html  
  https://quaternius.itch.io/universal-base-characters  
- **Quaternius — Universal Animation Library** — librería grande de clips para retargeting.  
  https://quaternius.com/packs/universalanimationlibrary.html  
  https://quaternius.itch.io/universal-animation-library  

## Materiales PBR y HDR (CC0)

- **Poly Haven** — texturas, modelos y HDRIs CC0.  
  https://polyhaven.com/  

## Armas y packs misceláneos

- Buscar en **Godot Asset Library** con filtro “CC0” o “MIT” y revisar el texto de licencia por asset:  
  https://godotengine.org/asset-library/asset  

## Importación en Godot

- Preferir **glTF 2.0 / `.glb`** cuando exista; revisar escala (1 unidad = 1 metro es una convención habitual) y **root type** en el importador.
- Para muchos props idénticos, considerar **`MultiMeshInstance3D`** más adelante; en etapa 1, instancias simples están bien.
