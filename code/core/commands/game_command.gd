class_name GameCommand
extends RefCounted
## Comando de dominio desacoplado del hardware.
## Solo systems/input debe crear instancias a partir del InputMap.

enum Type {
	MOVE_INTENT,
	PRIMARY_ACTION_PRESSED,
	CAST_SLOT_PRESSED,
}


var command_type: Type = Type.MOVE_INTENT
var move_direction: Vector2 = Vector2.ZERO
var slot_index: int = 1


static func move_intent(direction: Vector2) -> GameCommand:
	var command := GameCommand.new()
	command.command_type = Type.MOVE_INTENT
	command.move_direction = direction
	return command


static func primary_action_pressed() -> GameCommand:
	return cast_slot_pressed(1)


static func cast_slot_pressed(slot: int) -> GameCommand:
	var command := GameCommand.new()
	command.command_type = Type.CAST_SLOT_PRESSED
	command.slot_index = slot
	return command
