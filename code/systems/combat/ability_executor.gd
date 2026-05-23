class_name AbilityExecutor
extends RefCounted
## Valida y aplica costes + bloqueos temporales (MVP: solo instantáneas).


const DEFAULT_GCD := 1.0


static func try_use(
	clock: SimulationClock,
	locks: TemporalLocks,
	resources: ActorResources,
	ability: AbilityDefinition
) -> AbilityUseResult:
	if ability == null:
		return AbilityUseResult.fail(
			AbilityUseResult.Status.UNKNOWN_ABILITY, "habilidad_inexistente"
		)

	if ability.cast_time > 0.0:
		return AbilityUseResult.fail(
			AbilityUseResult.Status.CASTING,
			"cast_no_implementado",
			ability
		)

	if ability.respects_gcd and locks.is_gcd_active(clock):
		return AbilityUseResult.fail(
			AbilityUseResult.Status.ON_GCD, "gcd_activo", ability
		)

	if locks.is_ability_on_cooldown(ability.ability_id, clock):
		return AbilityUseResult.fail(
			AbilityUseResult.Status.ON_COOLDOWN, "cooldown_activo", ability
		)

	if not resources.can_pay(ability.energy_cost):
		return AbilityUseResult.fail(
			AbilityUseResult.Status.INSUFFICIENT_RESOURCE, "vigor_insuficiente", ability
		)

	if not resources.try_pay(ability.energy_cost):
		return AbilityUseResult.fail(
			AbilityUseResult.Status.INSUFFICIENT_RESOURCE, "vigor_insuficiente", ability
		)

	var gcd := ability.gcd_duration if ability.gcd_duration > 0.0 else DEFAULT_GCD
	if ability.respects_gcd:
		locks.start_gcd(clock, gcd)
	locks.start_ability_cooldown(ability.ability_id, clock, ability.cooldown_duration)

	return AbilityUseResult.success(ability)
