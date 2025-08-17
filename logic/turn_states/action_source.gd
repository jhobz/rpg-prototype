extends State

@export var action_target_state: State

@onready var game_manager: GameManager = %GameManager
@onready var ui_manager: UIManager = %UI

var animated_sprite: AnimatedSprite2D
var is_animating := false
var is_awaiting_dialogue := false

var instruction: Instruction

func enter() -> void:
	super.enter()
	instruction = game_manager.get_current_instruction()
	if instruction.action.action_name == "Oblivion" and instruction.action.iteration_count == 0:
		DialogueManager.play_demon_king_oblivion_dialogue()
		Globals.dialogue_completed.connect(_on_dialogue_completed)
		is_awaiting_dialogue = true
		return
	
	start_animation()

func start_animation() -> void:
	var source = instruction.source

	if source is PlayerCharacter:
		source.gui_component.toggle_action_menu(false)

	var animation := 'attack'
	# TODO: add an ActionType enum to Action and match case off of that instead of name
	match instruction.action.action_name:
		'Roll':
			animation = 'roll'
		'No Action':
			return
	
	is_animating = true
	animated_sprite = source.animated_sprite
	animated_sprite.play(animation)
	animated_sprite.animation_finished.connect(_on_animated_sprite_animation_finished)
	source.play_action_sfx(instruction.action)

func exit() -> void:
	super.exit()

func process(_delta: float) -> State:
	if is_awaiting_dialogue:
		return
	if is_animating:
		return

	return action_target_state

func cleanup():
	animated_sprite.animation_finished.disconnect(_on_animated_sprite_animation_finished)
	is_animating = false

func _on_animated_sprite_animation_finished():
	cleanup()

func _on_dialogue_completed():
	is_awaiting_dialogue = false
	Globals.dialogue_completed.disconnect(_on_dialogue_completed)
	start_animation()
