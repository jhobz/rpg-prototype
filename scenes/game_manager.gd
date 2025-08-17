class_name GameManager extends Node

@export var current_enemy: Character
@export var action_source_state: State
@export var turn_end_state: State

@onready var player_characters: Array[Node] = %Characters/Players.get_children()
@onready var state_machine: StateMachine = %GameStateMachine
@onready var turn_state_machine: StateMachine = %GameStateMachine/CharacterTurn/TurnStateMachine
@onready var ui_manager: UIManager = %UI
@onready var bgm_player: AudioStreamPlayer = %BGMPlayer

var instructions: Array[Instruction] = []
var current_instruction_index := 0
var current_character: Character
var current_enemy_instruction: Instruction

func _ready() -> void:
	Globals.game_manager = self
	DialogueManager.ui_manager = ui_manager
	ui_manager.ready.connect(
		func():
			state_machine.init_state_machine()
	)
	
	bgm_player.set_stream(Globals.default_music)
	bgm_player.play()

	for character in player_characters:
		if character is PlayerCharacter:
			var ui: ActionUIComponent = character.get_node('GUIComponent/ActionUIComponent')
			ui.action_selected.connect(_on_action_ui_component_action_selected)
	
func _process(delta: float):
	# TODO: these should prob be handled in StateMachine?
	state_machine.process_state_machine(delta)
	if turn_state_machine.current_state:
		turn_state_machine.process_state_machine(delta)

func log_instruction(instruction: Instruction) -> void:
	# TODO: can check for NonPlayerCharacter instead of setting to null
	if instruction.target == current_enemy:
		instruction.target = null
		
	instructions.append(instruction)
	ui_manager.add_instruction(instruction)
	Globals.save_state.new_instructions_this_encounter += 1

func playback_current_instruction():
	turn_state_machine.change_state(action_source_state)

func get_current_instruction() -> Instruction:
	if current_character is PlayerCharacter:
		return instructions[current_instruction_index]
	else:
		return current_enemy_instruction

func try_advance_playback():
	# end turn for characters who died
	if current_instruction_index < instructions.size() and instructions[current_instruction_index].source.is_dead():
		current_instruction_index += 1
		turn_state_machine.change_state(turn_end_state)
		return

	# we're done if we pass the end of the list
	if current_instruction_index >= instructions.size():
		ui_manager.set_active_instruction(-1)
		return

	var instruction = instructions[current_instruction_index]
	
	# if the next instruction is for the character whose turn it is, do it
	# otherwise, sit there until that character's turn comes up
	if instruction.source == current_character:
		execute_instruction(instructions[current_instruction_index])
		current_instruction_index += 1

func get_default_target_for_action(action: Action, source: Character) -> Character:
	match action.default_target:
		Action.DefaultActionTarget.NONE:
			return source
		Action.DefaultActionTarget.ENEMY:
			return current_enemy
		Action.DefaultActionTarget.ENEMY_ALL:
			return current_enemy
		Action.DefaultActionTarget.SELF:
			return source
	return null

func execute_instruction(instruction: Instruction):
	var target = instruction.target
	if not target:
		target = get_default_target_for_action(instruction.action, instruction.source)
	
	instruction.source.execute_action(instruction.action, target)

func replace_instruction_action_at_index(index: int, action: Action):
	var instruction = instructions[index]
	var target := get_default_target_for_action(action, instruction.source)

	instruction.action = action
	instruction.target = target
	ui_manager.replace_instruction_at_index(index, instruction)

#region Listeners

func _on_character_turn_turn_active(character: Character):
	current_character = character
	turn_state_machine.init_state_machine()

	if character is NonPlayerCharacter:
		current_enemy_instruction = character.get_turn_instruction()
		playback_current_instruction()
		return

	# if we have instructions left to execute, bypass player input
	if character is PlayerCharacter and current_instruction_index < instructions.size():
		if !character.is_dead() and instructions[current_instruction_index].action.action_name != 'Dead':
			character.gui_component.toggle_action_menu(false)
			ui_manager.set_active_instruction(current_instruction_index)
			playback_current_instruction()
			return

	if character is PlayerCharacter:
		if character.is_dead():
			if current_instruction_index >= instructions.size():
				var instruction = Instruction.new(Globals.dead_action, character, character)
				log_instruction(instruction)
			character.is_turn_complete = true
			current_instruction_index += 1
		else:
			character.gui_component.toggle_action_menu(true)
			if current_instruction_index < instructions.size():
				ui_manager.set_active_instruction(current_instruction_index)
			else:
				ui_manager.set_active_instruction(-1)


func _on_playback_button_pressed() -> void:
	if instructions.is_empty():
		return
	
	current_character.gui_component.toggle_action_menu(false)
	current_instruction_index = 0
	playback_current_instruction()

func _on_action_ui_component_action_selected(action: Action, source: Character) -> void:
	# safeguard in case the player gets the action UI up on the wrong turn somehow
	if current_character != source:
		return
	
	var target := get_default_target_for_action(action, source)

	if current_instruction_index < instructions.size():
		assert(instructions[current_instruction_index].action.action_name == 'Dead')
		replace_instruction_action_at_index(current_instruction_index, action)
	else:
		var instruction = Instruction.new(action, source, target)
		log_instruction(instruction)
	playback_current_instruction()

func _on_encounter_setup_encounter_started(encounter: Encounter) -> void:
	current_instruction_index = 0
	
	var next_music: AudioStream = null
	
	# this is totally the way you should check if it's the boss encounter lol
	if encounter.battles.size() == 1:
		next_music = Globals.boss_music
	elif bgm_player.stream == Globals.boss_music:
		next_music = Globals.default_music
		
	if next_music:
		var tween := bgm_player.create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_SINE)
		tween.finished.connect(_on_bgm_tween_finished.bind(next_music))
		tween.tween_property(bgm_player, "volume_db", -80.0, 1.0)

func _on_bgm_tween_finished(new_bgm: AudioStream):
	bgm_player.set_stream(new_bgm)
	bgm_player.set_volume_db(0.0)
	bgm_player.play()

#endregion
