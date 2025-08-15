extends State

@export var turn_end_state: State
@export var action_source_state: State

@onready var game_manager: GameManager = %GameManager
@onready var ui_manager: UIManager = %UI

var animated_sprite: AnimatedSprite2D
var is_animating := false
var is_awaiting_dialogue := false

var instruction: Instruction

func enter() -> void:
	super.enter()

	instruction = game_manager.get_current_instruction()
	var target = instruction.target if instruction.target else game_manager.current_enemy

	if instruction.source is PlayerCharacter:
		game_manager.try_advance_playback()
	else:
		game_manager.execute_instruction(instruction)

	match instruction.action.default_target:
		Action.DefaultActionTarget.NONE:
			return
		Action.DefaultActionTarget.SELF:
			return

	is_animating = true
	animated_sprite = target.get_node("AnimatedSprite2D")
	animated_sprite.animation_finished.connect(_on_animated_sprite_animation_finished)

	if instruction.action.default_target == Action.DefaultActionTarget.ENEMY_ALL:
		for character in CharacterManager.player_characters:
			var other_animated_sprite = character.get_node("AnimatedSprite2D")
			other_animated_sprite.play("hit")
			character.play_hit_sfx()
	else:
		animated_sprite.play("hit")
		target.play_hit_sfx()

func exit() -> void:
	super.exit()

func process(_delta: float) -> State:
	if is_animating:
		return
	if is_awaiting_dialogue:
		return

	if instruction.action.action_name == "Oblivion" and instruction.action.iteration_count != 0:
		return action_source_state
	else:
		return turn_end_state

func cleanup():
	animated_sprite.animation_finished.disconnect(_on_animated_sprite_animation_finished)
	is_animating = false
	if instruction.action.action_name == "Oblivion" and instruction.action.iteration_count == 0:
		is_awaiting_dialogue = true
		ui_manager.queue_message("Demon King: \"Now, it's time for some pain.\"")
		Globals.dialogue_completed.connect(_on_dialogue_completed)

func _on_animated_sprite_animation_finished():
	cleanup()

func _on_dialogue_completed():
	Globals.dialogue_completed.disconnect(_on_dialogue_completed)
	is_awaiting_dialogue = false
