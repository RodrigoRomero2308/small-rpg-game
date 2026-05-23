class_name EncounterController
extends Node
## Condiciones simples de victoria/derrota del encuentro MVP.


@export var player_health_path: NodePath = ^"../Player/HealthComponent"
@export var enemy_health_path: NodePath = ^"../TrainingDummy/HealthComponent"

var outcome: StringName = &"ongoing"


func _ready() -> void:
	var player_health := _get_health(player_health_path)
	var enemy_health := _get_health(enemy_health_path)
	if player_health:
		player_health.died.connect(_on_player_died)
	if enemy_health:
		enemy_health.died.connect(_on_enemy_died)
	CombatLog.add("[Encounter] Combate iniciado")


func _on_enemy_died() -> void:
	if outcome != &"ongoing":
		return
	outcome = &"victory"
	CombatLog.add("[Encounter] VICTORIA — objetivo derrotado")


func _on_player_died() -> void:
	if outcome != &"ongoing":
		return
	outcome = &"defeat"
	CombatLog.add("[Encounter] DERROTA — capitán caído")


func _get_health(path: NodePath) -> HealthComponent:
	var node := get_node_or_null(path)
	return node as HealthComponent
