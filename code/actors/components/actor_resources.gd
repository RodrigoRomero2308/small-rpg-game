class_name ActorResources
extends RefCounted
## Vigor (energy) del actor; pago atómico solo si hay suficiente.


var max_energy: float = 100.0
var energy: float = 100.0
var energy_regen_per_second: float = 8.0


func can_pay(cost: float) -> bool:
	return cost <= 0.0 or energy >= cost


func try_pay(cost: float) -> bool:
	if not can_pay(cost):
		return false
	energy -= cost
	return true


func regenerate(delta: float) -> void:
	if energy_regen_per_second <= 0.0:
		return
	energy = minf(max_energy, energy + energy_regen_per_second * delta)
