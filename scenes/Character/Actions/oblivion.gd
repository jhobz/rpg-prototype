class_name Oblivion extends Action

func _ready() -> void:
	action_name = 'Oblivion'

func execute(_source: Character, _target: Character) -> void:
	var instruction_index = Globals.game_manager.current_instruction_index
	for i in range(instruction_index, instruction_index + 9):
		if i >= Globals.game_manager.instructions.size():
			break
		
		Globals.game_manager.replace_instruction_action_at_index(i, Globals.nothing_action)
		# Globals.game_manager.instructions[i].action = Globals.nothing_action
		# Globals.game_manager.instructions[i].target = Globals.game_manager.instructions[i].source
