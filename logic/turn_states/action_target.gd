extends State

@export var turn_end_state: State

@onready var game_manager: GameManager = %GameManager

var animated_sprite: AnimatedSprite2D
var is_animating := false

func enter() -> void:
	super.enter()
	print('entering action target')

	is_animating = true
	var current_instruction: Instruction
	if game_manager.current_character is PlayerCharacter:
		current_instruction = game_manager.instructions[game_manager.current_instruction_index]
	else:
		current_instruction = game_manager.current_enemy_instruction
	
	var target = current_instruction.target if current_instruction.target else game_manager.current_enemy

	animated_sprite = target.get_node('AnimatedSprite2D')
	animated_sprite.animation_finished.connect(_on_animated_sprite_animation_finished)

	if current_instruction.source is PlayerCharacter:
		game_manager.try_advance_playback()
	else:
		game_manager.execute_instruction(current_instruction)

	# TODO: change this to a match case based on ActionType enum of the current instruction (e.g. cure vs. hit)
	if current_instruction.action.action_name == 'Roll' or current_instruction.action.action_name == 'No Action':
		cleanup()
		return

	animated_sprite.play('hit')

func exit() -> void:
	super.exit()

func process(_delta: float) -> State:
	if is_animating:
		return

	return turn_end_state

func cleanup():
	animated_sprite.animation_finished.disconnect(_on_animated_sprite_animation_finished)
	is_animating = false

func _on_animated_sprite_animation_finished():
	cleanup()
