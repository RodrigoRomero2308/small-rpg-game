class_name TemporalLocks
extends RefCounted
## GCD global y cooldowns por ability_id (timestamps absolutos en now).


var _gcd_until: float = 0.0
var _ability_until: Dictionary = {}


func is_gcd_active(clock: SimulationClock) -> bool:
	return clock.now < _gcd_until


func gcd_remaining(clock: SimulationClock) -> float:
	return maxf(0.0, _gcd_until - clock.now)


func is_ability_on_cooldown(ability_id: StringName, clock: SimulationClock) -> bool:
	if not _ability_until.has(ability_id):
		return false
	return clock.now < float(_ability_until[ability_id])


func ability_cooldown_remaining(ability_id: StringName, clock: SimulationClock) -> float:
	if not _ability_until.has(ability_id):
		return 0.0
	return maxf(0.0, float(_ability_until[ability_id]) - clock.now)


func start_gcd(clock: SimulationClock, duration: float) -> void:
	if duration <= 0.0:
		return
	_gcd_until = maxf(_gcd_until, clock.now + duration)


func start_ability_cooldown(
	ability_id: StringName, clock: SimulationClock, duration: float
) -> void:
	if duration <= 0.0:
		return
	var until := clock.now + duration
	if _ability_until.has(ability_id):
		until = maxf(until, float(_ability_until[ability_id]))
	_ability_until[ability_id] = until
