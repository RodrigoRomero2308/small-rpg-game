class_name CombatLog
extends RefCounted
## Registro de combate (estático) para overlay y consola.


const MAX_LINES := 10

static var _lines: PackedStringArray = PackedStringArray()


static func add(message: String) -> void:
	_lines.append(message)
	if _lines.size() > MAX_LINES:
		_lines = _lines.slice(_lines.size() - MAX_LINES, _lines.size())
	print(message)


static func get_log_text() -> String:
	if _lines.is_empty():
		return "(sin eventos)"
	return "\n".join(_lines)


static func clear() -> void:
	_lines = PackedStringArray()
