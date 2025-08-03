class_name NonPlayerCharacter extends Character

@onready var ai: AIComponent = $BattleAI

func _init() -> void:
	is_player_character = false

func get_turn_instruction() -> Instruction:
	var action = ai.select_action()
	var target = ai.select_target()

	return Instruction.new(action, self, target)
