extends Node

var game_manager: GameManager

var dead_action: Action
var nothing_action: Action

# TODO: Signal stuff would go in a global EventBus
signal next_run_requested()

func start_next_run():
	next_run_requested.emit()

func _input(event: InputEvent) -> void:
	if event.is_action('debug_increase_game_speed'):
		Engine.time_scale += 1
		print_debug("Increased game speed to ", Engine.time_scale)
	elif event.is_action('debug_decrease_game_speed'):
		Engine.time_scale = max(1, Engine.time_scale - 1)
		print_debug("Decreased game speed to ", Engine.time_scale)
	elif event.is_action('debug_reset_game_speed'):
		Engine.time_scale = 1
		print_debug("Reset game speed to ", Engine.time_scale)