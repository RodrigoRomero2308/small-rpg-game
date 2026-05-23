class_name GameCommand
extends RefCounted
## Comando de dominio desacoplado del hardware.
## Solo systems/input debe crear instancias a partir del InputMap.

enum Type {
	MOVE_INTENT,
	PRIMARY_ACTION_PRESSED,
}


var command_type: Type = Type.MOVE_INTENT
var move_direction: Vector2 = Vector2.ZERO


static func move_intent(direction: Vector2) -> GameCommand:
	var command := GameCommand.new()
	command.command_type = Type.MOVE_INTENT
	command.move_direction = direction
	return command


static func primary_action_pressed() -> GameCommand:
	var command := GameCommand.new()
	command.command_type = Type.PRIMARY_ACTION_PRESSED
	return command
