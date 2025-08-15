class_name Oblivion extends Action

var iteration_count := 0

func _ready() -> void:
	action_name = 'Oblivion'
	tooltip = 'Consign the next nine actions to oblivion, replacing them with No Action.'

func execute(_source: Character, _target: Character) -> void:
	var instruction_index = Globals.game_manager.current_instruction_index + iteration_count * 3
	iteration_count = wrapi(iteration_count + 1, 0, 3)
	for i in range(instruction_index, instruction_index + 3):
		if i >= Globals.game_manager.instructions.size():
			break
		
		Globals.game_manager.replace_instruction_action_at_index(i, Globals.nothing_action)
