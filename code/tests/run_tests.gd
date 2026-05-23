extends SceneTree
## Runner headless: godot --headless -s res://tests/run_tests.gd


func _initialize() -> void:
	var failures := 0
	failures += _test_resource_payment()
	failures += _test_gcd_blocks_second_use()
	failures += _test_ability_cooldown()
	failures += _test_insufficient_resource_no_gcd()
	failures += _test_health_damage_and_death()
	failures += _test_damage_applicator()

	if failures > 0:
		push_error("Tests fallidos: %d" % failures)
		quit(1)
	else:
		print("[Tests] OK (6 suites)")
		quit(0)


func _test_resource_payment() -> int:
	var resources := ActorResources.new()
	resources.energy = 20.0
	if not resources.try_pay(15.0):
		return 1
	if resources.try_pay(10.0):
		return 1
	return 0


func _test_gcd_blocks_second_use() -> int:
	var clock := SimulationClock.new()
	var locks := TemporalLocks.new()
	var resources := ActorResources.new()
	var ability := AbilityDefinition.new()
	ability.ability_id = &"test_slash"
	ability.energy_cost = 5.0
	ability.gcd_duration = 1.0

	var first := AbilityExecutor.try_use(clock, locks, resources, ability)
	if not first.succeeded():
		return 1
	clock.advance(0.2)
	var second := AbilityExecutor.try_use(clock, locks, resources, ability)
	if second.status != AbilityUseResult.Status.ON_GCD:
		return 1
	return 0


func _test_ability_cooldown() -> int:
	var clock := SimulationClock.new()
	var locks := TemporalLocks.new()
	var resources := ActorResources.new()
	var ability := AbilityDefinition.new()
	ability.ability_id = &"test_shot"
	ability.energy_cost = 5.0
	ability.cooldown_duration = 4.0
	ability.gcd_duration = 0.5
	ability.respects_gcd = true

	AbilityExecutor.try_use(clock, locks, resources, ability)
	clock.advance(2.0)
	var blocked := AbilityExecutor.try_use(clock, locks, resources, ability)
	if blocked.status != AbilityUseResult.Status.ON_COOLDOWN:
		return 1
	clock.advance(3.0)
	var ok := AbilityExecutor.try_use(clock, locks, resources, ability)
	if not ok.succeeded():
		return 1
	return 0


func _test_insufficient_resource_no_gcd() -> int:
	var clock := SimulationClock.new()
	var locks := TemporalLocks.new()
	var resources := ActorResources.new()
	resources.energy = 5.0
	var ability := AbilityDefinition.new()
	ability.ability_id = &"test_big"
	ability.energy_cost = 50.0
	ability.gcd_duration = 1.0

	var fail := AbilityExecutor.try_use(clock, locks, resources, ability)
	if fail.status != AbilityUseResult.Status.INSUFFICIENT_RESOURCE:
		return 1
	if locks.is_gcd_active(clock):
		return 1
	if resources.energy < 5.0:
		return 1
	return 0


func _test_health_damage_and_death() -> int:
	var health := HealthComponent.new()
	health.max_health = 30.0
	health.current_health = 30.0
	var dealt := health.apply_damage(10.0)
	if dealt != 10.0 or health.current_health != 20.0:
		return 1
	health.apply_damage(50.0)
	if health.is_alive():
		return 1
	return 0


func _test_damage_applicator() -> int:
	var health := HealthComponent.new()
	health.max_health = 50.0
	health.current_health = 50.0
	var ability := AbilityDefinition.new()
	ability.damage = 18.0
	var dealt := DamageApplicator.apply_ability(ability, health)
	if dealt != 18.0 or health.current_health != 32.0:
		return 1
	return 0
