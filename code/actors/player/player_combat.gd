class_name PlayerCombat
extends Node
## Combate MVP: vigor, GCD, CDs y ejecución de slots 1–3.

signal ability_used(result: AbilityUseResult)
signal ability_rejected(result: AbilityUseResult)


@export var loadout: AbilityLoadout

var clock: SimulationClock = SimulationClock.new()
var locks: TemporalLocks = TemporalLocks.new()
var resources: ActorResources = ActorResources.new()


func _ready() -> void:
	if loadout == null:
		loadout = preload("res://content/abilities/pirate_default_loadout.tres")


func _physics_process(delta: float) -> void:
	clock.advance(delta)
	resources.regenerate(delta)


func try_cast_slot(slot_index: int) -> AbilityUseResult:
	var ability := loadout.get_ability_for_slot(slot_index) if loadout else null
	var result := AbilityExecutor.try_use(clock, locks, resources, ability)
	if result.succeeded():
		ability_used.emit(result)
		print(
			"[Combat] ",
			ability.display_name,
			" (slot ",
			slot_index,
			") vigor=",
			snapped(resources.energy, 0.1)
		)
	else:
		ability_rejected.emit(result)
		var name := ability.display_name if ability else "?"
		print("[Combat] RECHAZADO ", name, ": ", result.message)
	return result


func get_debug_state() -> Dictionary:
	return {
		"energy": resources.energy,
		"max_energy": resources.max_energy,
		"gcd_remaining": locks.gcd_remaining(clock),
		"slot_1_cd": _cd_for_slot(1),
		"slot_2_cd": _cd_for_slot(2),
		"slot_3_cd": _cd_for_slot(3),
	}


func _cd_for_slot(slot_index: int) -> float:
	var ability := loadout.get_ability_for_slot(slot_index) if loadout else null
	if ability == null:
		return 0.0
	return locks.ability_cooldown_remaining(ability.ability_id, clock)
