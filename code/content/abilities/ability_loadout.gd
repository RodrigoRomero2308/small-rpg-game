class_name AbilityLoadout
extends Resource


@export var slot_1: AbilityDefinition
@export var slot_2: AbilityDefinition
@export var slot_3: AbilityDefinition


func get_ability_for_slot(slot_index: int) -> AbilityDefinition:
	match slot_index:
		1:
			return slot_1
		2:
			return slot_2
		3:
			return slot_3
		_:
			return null
