class_name PlayerCombat
extends Node
## Combate MVP: vigor, GCD, CDs, daño a objetivo y slots 1–3.

signal ability_used(result: AbilityUseResult)
signal ability_rejected(result: AbilityUseResult)


@export var loadout: AbilityLoadout
@export var target_health_path: NodePath

var clock: SimulationClock = SimulationClock.new()
var locks: TemporalLocks = TemporalLocks.new()
var resources: ActorResources = ActorResources.new()

var _target_health: HealthComponent


func _ready() -> void:
	if loadout == null:
		loadout = preload("res://content/abilities/pirate_default_loadout.tres")
	_resolve_target()


func _physics_process(delta: float) -> void:
	clock.advance(delta)
	resources.regenerate(delta)


func try_cast_slot(slot_index: int) -> AbilityUseResult:
	var ability := loadout.get_ability_for_slot(slot_index) if loadout else null
	var target := _resolve_target()
	if target == null:
		var no_target := AbilityUseResult.fail(
			AbilityUseResult.Status.UNKNOWN_ABILITY, "sin_objetivo", ability
		)
		CombatLog.add("[Combat] sin objetivo válido")
		ability_rejected.emit(no_target)
		return no_target
	if not target.is_alive():
		var dead_target := AbilityUseResult.fail(
			AbilityUseResult.Status.UNKNOWN_ABILITY, "objetivo_muerto", ability
		)
		CombatLog.add("[Combat] objetivo ya derrotado")
		ability_rejected.emit(dead_target)
		return dead_target

	var result := AbilityExecutor.try_use(clock, locks, resources, ability)
	if result.succeeded():
		result.damage_dealt = DamageApplicator.apply_ability(ability, target)
		ability_used.emit(result)
		CombatLog.add(
			"[Combat] %s → %.0f dmg (objetivo %.0f HP)" % [
				ability.display_name, result.damage_dealt, target.current_health
			]
		)
	else:
		ability_rejected.emit(result)
		var reject_name := ability.display_name if ability else "?"
		CombatLog.add("[Combat] RECHAZADO %s: %s" % [reject_name, result.message])
	return result


func get_debug_state() -> Dictionary:
	var target := _resolve_target()
	return {
		"energy": resources.energy,
		"max_energy": resources.max_energy,
		"gcd_remaining": locks.gcd_remaining(clock),
		"slot_1_cd": _cd_for_slot(1),
		"slot_2_cd": _cd_for_slot(2),
		"slot_3_cd": _cd_for_slot(3),
		"target_health": target.current_health if target else 0.0,
		"target_max_health": target.max_health if target else 0.0,
	}


func _cd_for_slot(slot_index: int) -> float:
	var ability := loadout.get_ability_for_slot(slot_index) if loadout else null
	if ability == null:
		return 0.0
	return locks.ability_cooldown_remaining(ability.ability_id, clock)


func _resolve_target() -> HealthComponent:
	if _target_health != null and is_instance_valid(_target_health):
		if _target_health.is_alive():
			return _target_health
	if not target_health_path.is_empty():
		var node := get_node_or_null(target_health_path)
		if node is HealthComponent:
			_target_health = node
			return _target_health
	for candidate: Node in get_tree().get_nodes_in_group("combat_targets"):
		var health := candidate.get_node_or_null("HealthComponent") as HealthComponent
		if health and health.is_alive():
			_target_health = health
			return _target_health
	return null
