class_name AbilityUseResult
extends RefCounted


enum Status {
	SUCCESS,
	UNKNOWN_ABILITY,
	ON_GCD,
	ON_COOLDOWN,
	INSUFFICIENT_RESOURCE,
	CASTING,
}


var status: Status = Status.UNKNOWN_ABILITY
var ability: AbilityDefinition
var message: String = ""


static func success(used_ability: AbilityDefinition) -> AbilityUseResult:
	var result := AbilityUseResult.new()
	result.status = Status.SUCCESS
	result.ability = used_ability
	result.message = "ok"
	return result


static func fail(
	fail_status: Status, fail_message: String, fail_ability: AbilityDefinition = null
) -> AbilityUseResult:
	var result := AbilityUseResult.new()
	result.status = fail_status
	result.ability = fail_ability
	result.message = fail_message
	return result


func succeeded() -> bool:
	return status == Status.SUCCESS
