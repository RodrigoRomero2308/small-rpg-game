class_name CombatDebugOverlay
extends CanvasLayer
## Overlay mínimo: vigor, GCD y CDs por slot.


@export var player_combat_path: NodePath = ^"../Player/PlayerCombat"

var _combat: PlayerCombat
var _label: Label


func _ready() -> void:
	layer = 100
	_label = Label.new()
	_label.position = Vector2(8, 8)
	_label.add_theme_font_size_override("font_size", 14)
	add_child(_label)
	_resolve_combat()


func _process(_delta: float) -> void:
	if _combat == null:
		_resolve_combat()
		if _combat == null:
			_label.text = "CombatDebug: sin PlayerCombat"
			return

	var state: Dictionary = _combat.get_debug_state()
	_label.text = (
		"Vigor: %0.0f / %0.0f\nGCD: %.1fs\nCD slot1: %.1fs | slot2: %.1fs | slot3: %.1fs"
		% [
			state["energy"],
			state["max_energy"],
			state["gcd_remaining"],
			state["slot_1_cd"],
			state["slot_2_cd"],
			state["slot_3_cd"],
		]
	)


func _resolve_combat() -> void:
	if player_combat_path.is_empty():
		return
	var node := get_node_or_null(player_combat_path)
	if node is PlayerCombat:
		_combat = node
