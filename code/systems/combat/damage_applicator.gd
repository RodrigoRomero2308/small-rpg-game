class_name DamageApplicator
extends RefCounted
## Aplica el payload de daño de una habilidad a un HealthComponent.


static func apply_ability(ability: AbilityDefinition, target: HealthComponent) -> float:
	if ability == null or target == null:
		return 0.0
	return target.apply_damage(ability.damage)
