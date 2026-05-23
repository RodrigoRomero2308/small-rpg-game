extends SceneTree
## Demo automatizado: movimiento, 3 habilidades y combate hasta victoria.
## Env: CAPTURE_DIR, CAPTURE_SECONDS (default 14), CAPTURE_FPS, OVERLAY_MODE


const MAIN_SCENE := preload("res://scenes/main.tscn")


func _initialize() -> void:
	var capture_dir := OS.get_environment("CAPTURE_DIR")
	if capture_dir.is_empty():
		capture_dir = ProjectSettings.globalize_path(
			"user://captures/%s" % Time.get_datetime_string_from_system().replace(":", "-")
		)
	var duration := float(
		OS.get_environment("CAPTURE_SECONDS") if OS.has_environment("CAPTURE_SECONDS") else "14"
	)
	var fps := int(OS.get_environment("CAPTURE_FPS") if OS.has_environment("CAPTURE_FPS") else "15")

	DirAccess.make_dir_recursive_absolute(capture_dir)
	print("[Capture] salida: ", capture_dir)

	CombatLog.clear()

	var main := MAIN_SCENE.instantiate()
	root.add_child(main)

	var driver := CaptureDriver.new()
	driver.main = main
	driver.capture_dir = capture_dir
	driver.duration = duration
	driver.fps = fps
	root.add_child(driver)


class CaptureDriver extends Node:
	var main: Node2D
	var capture_dir: String = ""
	var duration: float = 14.0
	var fps: int = 15

	var _frame_interval: float = 1.0 / 15.0
	var _elapsed: float = 0.0
	var _next_frame_at: float = 0.0
	var _frame_index: int = 0
	var _done: bool = false
	var _player: Player
	var _combat: PlayerCombat
	var _enemy_health: HealthComponent


	func _ready() -> void:
		_frame_interval = 1.0 / maxf(1, fps)
		_player = main.get_node_or_null("Player") as Player
		_combat = main.get_node_or_null("Player/PlayerCombat") as PlayerCombat
		_enemy_health = main.get_node_or_null("TrainingDummy/HealthComponent") as HealthComponent
		if _combat == null or _enemy_health == null:
			push_error("demo_playback: faltan nodos de combate")
			get_tree().quit(1)
			return
		CombatLog.add("[Capture] Demo combate iniciado")
		_run_demo()


	func _run_demo() -> void:
		await get_tree().process_frame
		await get_tree().process_frame
		_save_frame()

		await _press_move(&"move_right", 0.9)

		var rotation := 0
		while _enemy_health.is_alive() and _elapsed < duration - 0.3 and rotation < 8:
			_tap_slot(1)
			await get_tree().create_timer(1.05).timeout
			if not _enemy_health.is_alive():
				break
			_tap_slot(2)
			await get_tree().create_timer(1.05).timeout
			if not _enemy_health.is_alive():
				break
			_tap_slot(3)
			await get_tree().create_timer(1.05).timeout
			rotation += 1

		if _enemy_health.is_alive():
			CombatLog.add("[Capture] Objetivo sigue vivo (timeout demo)")
		else:
			CombatLog.add("[Capture] Objetivo derrotado en demo")

		while _elapsed < duration:
			await get_tree().process_frame
		_finish()


	func _process(delta: float) -> void:
		if _done:
			return
		_elapsed += delta
		if _elapsed >= _next_frame_at:
			_save_frame()
			_next_frame_at += _frame_interval


	func _press_move(action: StringName, seconds: float) -> void:
		Input.action_press(action)
		var remaining := seconds
		while remaining > 0.0 and not _done:
			await get_tree().create_timer(minf(remaining, 0.05)).timeout
			remaining -= 0.05
		Input.action_release(action)


	func _tap_slot(slot: int) -> void:
		if _combat:
			_combat.try_cast_slot(slot)
		await get_tree().process_frame


	func _save_frame() -> void:
		await RenderingServer.frame_post_draw
		var texture: Texture2D = get_tree().root.get_texture()
		if texture == null:
			return
		var image := texture.get_image()
		if image == null or image.is_empty():
			return
		var path := "%s/frame_%04d.png" % [capture_dir, _frame_index]
		if image.save_png(path) == OK:
			print("[Capture] ", path)
		_frame_index += 1


	func _finish() -> void:
		if _done:
			return
		_done = true
		_save_frame()
		var meta := FileAccess.open("%s/meta.txt" % capture_dir, FileAccess.WRITE)
		if meta:
			meta.store_line("frames=%d" % _frame_index)
			meta.store_line("duration=%.2f" % _elapsed)
			meta.store_line("fps=%d" % fps)
			meta.store_line("overlay=%s" % OS.get_environment("OVERLAY_MODE"))
			meta.close()
		print("[Capture] listo: %d frames" % _frame_index)
		get_tree().quit(0)
