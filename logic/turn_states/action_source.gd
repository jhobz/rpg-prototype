extends State

@export var action_target_state: State

@onready var game_manager: GameManager = %GameManager

var animated_sprite: AnimatedSprite2D
var is_animating := false

func enter() -> void:
	super.enter()

	is_animating = true
	var current_instruction: Instruction
	if game_manager.current_character is PlayerCharacter:
		current_instruction = game_manager.instructions[game_manager.current_instruction_index]
	else:
		current_instruction = game_manager.current_enemy_instruction
		print('current_instruction: ' + current_instruction.action.action_name + current_instruction.source.char_name + current_instruction.target.char_name)
	var source = current_instruction.source

	if source is PlayerCharacter:
		source.gui_component.toggle_action_menu(false)

	animated_sprite = source.get_node('AnimatedSprite2D')
	animated_sprite.animation_finished.connect(_on_animated_sprite_animation_finished)
	# TODO: add an ActionType enum to Action and match case off of that instead of name
	match current_instruction.action.action_name:
		'Attack':
			animated_sprite.play('attack')
		'Roll':
			animated_sprite.play('roll')
		_:
			animated_sprite.play('attack')

func exit() -> void:
	super.exit()

func process(_delta: float) -> State:
	if is_animating:
		return

	return action_target_state

func cleanup():
	animated_sprite.animation_finished.disconnect(_on_animated_sprite_animation_finished)
	is_animating = false

func _on_animated_sprite_animation_finished():
	cleanup()
