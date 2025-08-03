class_name SimpleAttackAIComponent extends AIComponent

@export var attack_action: Action

func _ready() -> void:
	pass

func select_action() -> Action:
	return attack_action
