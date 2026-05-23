class_name PlayerInputReader
extends Node
## Única capa que conoce acciones del InputMap.
## Convierte hardware en comandos de dominio para el tick actual.


func poll_commands() -> Array[GameCommand]:
	var commands: Array[GameCommand] = []

	var move_direction := Input.get_vector(
		&"move_left", &"move_right", &"move_up", &"move_down"
	)
	if move_direction != Vector2.ZERO:
		commands.append(GameCommand.move_intent(move_direction))

	if Input.is_action_just_pressed(&"primary_action"):
		commands.append(GameCommand.primary_action_pressed())

	return commands
