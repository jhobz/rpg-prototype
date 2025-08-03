class_name BossAttackAIComponent extends AIComponent

@export var attack_action: Action
@export var special_action: Action
@export var cleave_action: Action

var _turn_count := 0

func _ready() -> void:
	assert(attack_action)
	assert(special_action)
	assert(cleave_action)

func select_action() -> Action:
	_turn_count += 1

	if _turn_count == 1:
		return cleave_action
	if _turn_count == 2:
		return special_action
	
	if (_turn_count - 2) % 3:
		return attack_action

	return cleave_action
