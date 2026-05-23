class_name Player
extends CharacterBody2D
## Actor jugable: aplica comandos abstractos (movimiento y acción principal).
## No lee Input.* directamente.


@export var move_speed: float = 220.0

@onready var _input_reader: PlayerInputReader = $PlayerInputReader
@onready var _combat: PlayerCombat = $PlayerCombat


func _physics_process(_delta: float) -> void:
	var move_direction := Vector2.ZERO

	for command: GameCommand in _input_reader.poll_commands():
		match command.command_type:
			GameCommand.Type.MOVE_INTENT:
				move_direction = command.move_direction
			GameCommand.Type.PRIMARY_ACTION_PRESSED, GameCommand.Type.CAST_SLOT_PRESSED:
				_combat.try_cast_slot(command.slot_index)

	if move_direction != Vector2.ZERO:
		velocity = move_direction.normalized() * move_speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

