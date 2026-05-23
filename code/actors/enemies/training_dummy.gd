class_name TrainingDummy
extends StaticBody2D
## Enemigo estático MVP para validar daño y victoria.


@onready var health: HealthComponent = $HealthComponent


func _ready() -> void:
	add_to_group("combat_targets")
	if health:
		health.damaged.connect(_on_damaged)


func _on_damaged(_amount: float, remaining: float) -> void:
	var visual := get_node_or_null("Visual") as ColorRect
	if visual == null:
		return
	if remaining <= 0.0:
		visual.color = Color(0.25, 0.25, 0.28, 0.6)
		return
	visual.color = Color(0.95, 0.35, 0.3, 1.0)
	await get_tree().create_timer(0.12).timeout
	if health.is_alive():
		visual.color = Color(0.82, 0.22, 0.22, 1.0)
