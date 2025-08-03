extends State

@export var action_target_state: State

@onready var game_manager: GameManager = %GameManager

var animated_sprite: AnimatedSprite2D
var is_animating := false

func enter() -> void:
	super.enter()

	var current_instruction: Instruction
	if game_manager.current_character is PlayerCharacter:
		current_instruction = game_manager.instructions[game_manager.current_instruction_index]
	else:
		current_instruction = game_manager.current_enemy_instruction
	var source = current_instruction.source

	if source is PlayerCharacter:
		source.gui_component.toggle_action_menu(false)

	var animation := 'attack'
	# TODO: add an ActionType enum to Action and match case off of that instead of name
	match current_instruction.action.action_name:
		'Roll':
			animation = 'roll'
		'No Action':
			return
	
	is_animating = true
	animated_sprite = source.animated_sprite
	animated_sprite.play(animation)
	animated_sprite.animation_finished.connect(_on_animated_sprite_animation_finished)

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
