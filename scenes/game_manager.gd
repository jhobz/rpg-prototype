class_name GameManager extends Node

@export var current_enemy: Character
@export var action_source_state: State

@onready var player_characters: Array[Node] = %Characters/Players.get_children()
@onready var state_machine: StateMachine = %GameStateMachine
@onready var turn_state_machine: StateMachine = %GameStateMachine/CharacterTurn/TurnStateMachine
@onready var instructions_control: Control = %Instructions

var instructions: Array[Instruction] = []
var current_instruction_index := 0
var current_character: Character
var current_enemy_instruction: Instruction

func _ready() -> void:
	state_machine.init_state_machine()

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
	var instructions_list = instructions_control.get_node('PanelContainer/VBoxContainer/InstructionList')
	var target_name = instruction.target.char_name
	
	# TODO: can check for NonPlayerCharacter instead of setting to null
	if instruction.target == current_enemy:
		target_name = "Enemy"
		instruction.target = null
		
	instructions.append(instruction)
	instructions_list.add_item(instruction.source.char_name)
	instructions_list.add_item(instruction.action.action_name)
	instructions_list.add_item(target_name)

func playback_current_instruction():
	turn_state_machine.change_state(action_source_state)

func try_advance_playback():
	# we're done if we pass the end of the list
	if current_instruction_index >= instructions.size():
		print('done executing playback')
		return

	var instruction = instructions[current_instruction_index]

	# skip instructions that are for characters who died
	while current_instruction_index < instructions.size() and instruction.source.is_dead():
		var skip_instruction = instructions[current_instruction_index]
		print('skipping instruction because character is dead', skip_instruction.action, skip_instruction.source, skip_instruction.target)
		current_instruction_index += 1
	
	# if the next instruction is for the character whose turn it is, do it
	# otherwise, sit there until that character's turn comes up
	if instruction.source == current_character:
		execute_instruction(instructions[current_instruction_index])
		current_instruction_index += 1

func execute_instruction(instruction: Instruction):
	var target = instruction.target
	if not target:
		target = current_enemy

	instruction.source.execute_action(instruction.action, target)


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
		character.gui_component.toggle_action_menu(false)
		playback_current_instruction()
		return

	if character is PlayerCharacter:
		character.gui_component.toggle_action_menu(true)


func _on_playback_button_pressed() -> void:
	if instructions.is_empty():
		print('nothing to play back!')
		return
	
	current_character.gui_component.toggle_action_menu(false)
	current_instruction_index = 0
	playback_current_instruction()

func _on_action_ui_component_action_selected(action: Action, source: Character) -> void:
	# safeguard in case the player gets the action UI up on the wrong turn somehow
	if current_character != source:
		return
	
	var target = current_enemy
	if action.action_name == 'Roll':
		target = source

	var instruction = Instruction.new(action, source, target)
	log_instruction(instruction)
	playback_current_instruction()

func _on_encounter_setup_encounter_started() -> void:
	current_instruction_index = 0

#endregion
