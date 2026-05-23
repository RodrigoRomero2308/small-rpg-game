class_name HealthComponent
extends Node
## Vida del actor; autoridad de HP para daño y muerte.


signal damaged(amount: float, remaining: float)
signal died
signal health_changed(current: float, maximum: float)


@export var max_health: float = 100.0

var current_health: float = 100.0


func _ready() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)


func is_alive() -> bool:
	return current_health > 0.0


func apply_damage(amount: float) -> float:
	if amount <= 0.0 or not is_alive():
		return 0.0
	var dealt := minf(amount, current_health)
	current_health -= dealt
	damaged.emit(dealt, current_health)
	health_changed.emit(current_health, max_health)
	if not is_alive():
		died.emit()
	return dealt
