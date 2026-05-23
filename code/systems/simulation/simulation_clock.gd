class_name SimulationClock
extends RefCounted
## Reloj de simulación del actor; avanza en el tick de física.


var now: float = 0.0


func advance(delta: float) -> void:
	now += delta


func reset() -> void:
	now = 0.0
