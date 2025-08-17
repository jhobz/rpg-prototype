extends Node

var game_manager: GameManager
var dead_action: Action
var nothing_action: Action
var save_state: Dictionary = {
	"has_cleared_first_encounter": false,
	"has_seen_instruction_tutorial": false,
	"has_seen_editing_tutorial": false,
	"current_run": null,
	"current_encounter_index": 0,
	"current_battle_index": 0,
	"new_instructions_this_encounter": 0,
	"current_run_count": 0,
}

var default_music: AudioStream = preload("res://assets/audio/11. Dangerous Cave.ogg")
var boss_music: AudioStream = preload("res://assets/audio/15. Volcanic Crater.ogg")

# TODO: Signal stuff would go in a global EventBus
signal next_run_requested()
signal dialogue_completed()

func start_next_run():
	next_run_requested.emit()
	save_state.current_run_count += 1

func start_battle(battle_index: int):
	save_state.current_battle_index = battle_index

func start_encounter(encounter_index: int):
	save_state.current_encounter_index = encounter_index
	save_state.new_instructions_this_encounter = 0
	start_battle(0)

func _input(event: InputEvent) -> void:
	if event.is_action_released('debug_increase_game_speed'):
		# TODO: check for debug
		Engine.time_scale += 1
		print_debug("Increased game speed to ", Engine.time_scale)
		return

	if event.is_action_released('debug_decrease_game_speed'):
		# TODO: check for debug
		Engine.time_scale = max(1, Engine.time_scale - 1)
		print_debug("Decreased game speed to ", Engine.time_scale)
		return

	if event.is_action_released('debug_reset_game_speed'):
		# TODO: check for debug
		Engine.time_scale = 1
		print_debug("Reset game speed to ", Engine.time_scale)
		return
