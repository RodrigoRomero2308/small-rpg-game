class_name CombatDebugOverlay
extends CanvasLayer
## Overlay: stats de combate y log en pantalla (modo gameplay o log).


@export var player_combat_path: NodePath
@export var player_health_path: NodePath
@export var enemy_health_path: NodePath

var _combat: PlayerCombat
var _player_health: HealthComponent
var _enemy_health: HealthComponent
var _label: Label
var _mode: String = "gameplay"


func _ready() -> void:
	layer = 100
	_mode = OS.get_environment("OVERLAY_MODE") if OS.has_environment("OVERLAY_MODE") else "gameplay"
	_label = Label.new()
	_label.position = Vector2(8, 8)
	var font_size := 16 if _mode == "log" else 14
	_label.add_theme_font_size_override("font_size", font_size)
	if _mode == "log":
		_label.custom_minimum_size = Vector2(624, 344)
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_label)
	_resolve_nodes()


func _process(_delta: float) -> void:
	if _combat == null:
		_resolve_nodes()
		if _combat == null:
			_label.text = "CombatDebug: sin PlayerCombat"
			return

	if _mode == "log":
		_label.text = _build_log_overlay()
	else:
		_label.text = _build_gameplay_overlay()


func _build_gameplay_overlay() -> String:
	var state: Dictionary = _combat.get_debug_state()
	var player_hp := _format_health(_player_health)
	var enemy_hp := _format_health(_enemy_health)
	var last_log := _last_log_line()
	return (
		"Capitán HP: %s | Objetivo HP: %s\nVigor: %0.0f / %0.0f | GCD: %.1fs\nCD: %.1f | %.1f | %.1f\nÚltimo: %s"
		% [
			player_hp,
			enemy_hp,
			state["energy"],
			state["max_energy"],
			state["gcd_remaining"],
			state["slot_1_cd"],
			state["slot_2_cd"],
			state["slot_3_cd"],
			last_log,
		]
	)


func _build_log_overlay() -> String:
	var state: Dictionary = _combat.get_debug_state()
	var header := (
		"=== Log de combate ===\nCapitán %s | Objetivo %s | Vigor %.0f\n\n"
		% [
			_format_health(_player_health),
			_format_health(_enemy_health),
			state["energy"],
		]
	)
	return header + CombatLog.get_log_text()


func _format_health(health: HealthComponent) -> String:
	if health == null:
		return "? / ?"
	return "%.0f / %.0f" % [health.current_health, health.max_health]


func _last_log_line() -> String:
	var lines := CombatLog.get_log_text().split("\n")
	if lines.is_empty():
		return "—"
	return lines[lines.size() - 1]


func _resolve_nodes() -> void:
	if not player_combat_path.is_empty():
		_combat = get_node_or_null(player_combat_path) as PlayerCombat
	if not player_health_path.is_empty():
		_player_health = get_node_or_null(player_health_path) as HealthComponent
	if not enemy_health_path.is_empty():
		_enemy_health = get_node_or_null(enemy_health_path) as HealthComponent
