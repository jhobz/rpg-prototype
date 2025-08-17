extends MarginContainer
class_name UIManager

@onready var instructions_control: InstructionsUIManager = %Instructions
@onready var status_container: CenterContainer = %StatusContainer
@onready var status_label: RichTextLabel = %Status
@onready var run_results_panel: VBoxContainer = %RunResultsPanel
@onready var results_container: HFlowContainer = %ResultsContainer
@onready var advance_dialogue_icon: TextureRect = %AdvanceDialogueIcon

var _messages: Array = []
var _is_showing_message: bool = false

func _ready() -> void:
	set_instructions_input_enabled(false)
	toggle_instruction_list(false)
	hide_run_results()

func _process(_delta: float) -> void:
	if !_is_showing_message and _messages.size():
		show_message()

# Instructions

func add_instruction(instruction: Instruction) -> void:
	instructions_control.add_instruction(instruction)

func replace_instruction_at_index(index: int, instruction: Instruction) -> void:
	instructions_control.replace_instruction_at_index(index, instruction)

func set_instructions_input_enabled(enabled: bool) -> void:
	instructions_control.toggle_input(enabled)

func set_active_instruction(index: int) -> void:
	instructions_control.set_active_instruction(index)

func toggle_instruction_list(state: bool) -> void:
	if state:
		instructions_control.show()
	else:
		instructions_control.hide()

# Messages

func queue_message(message: String, duration: float = 0) -> void:
	var message_data := {
		"text": message,
	}

	if duration:
		message_data.duration = duration

	_messages.push_back(message_data)

func queue_messages(messages: Array, duration: float = 0):
	for message in messages:
		queue_message(message, duration)

func show_message() -> void:
	if _messages.size() == 0:
		return

	var message: Dictionary = _messages.pop_front()
	status_label.text = message.text
	advance_dialogue_icon.show()
	status_container.show()
	_is_showing_message = true

	if message.has('duration'):
		get_tree().create_timer(message.duration).timeout.connect(hide_message)
		advance_dialogue_icon.hide()

func hide_message() -> void:
	status_container.hide()
	_is_showing_message = false

	if _messages.size():
		show_message()
		return

	Globals.dialogue_completed.emit()

# Run results

func show_run_results() -> void:
	var title = run_results_panel.get_node("Panel/MarginContainer/VBoxContainer/ResultsTitle")
	title.text = DialogueManager.get_post_death_title()
	run_results_panel.show()

func hide_run_results() -> void:
	run_results_panel.hide()

func populate_run_results(run: Run) -> void:
	_clear_run_results()

	var current_encounter_index = Globals.save_state.current_encounter_index
	var current_battle_index = Globals.save_state.current_battle_index
	var encounter_index := 0
	
	for encounter in run.encounters:
		var scene: PackedScene = load("res://scenes/UI/results_encounter_group.tscn")
		var node := scene.instantiate()
		results_container.add_child(node)
		var battle_index := 0

		for battle in encounter.battles:
			for enemy in battle.enemies:
				var container: HBoxContainer = node.get_node("MarginContainer/HBoxContainer")
				var enemy_node: TextureRect = container.get_node("Placeholder").duplicate()
				var npc: NonPlayerCharacter = enemy.instantiate()
				var scale_factor := 3 if npc.char_name == "Demon King" else 2 if npc.char_name == "Zombie Mage" else 4
				enemy_node.texture = npc.end_screen_image_dead
				enemy_node.custom_minimum_size = enemy_node.texture.get_size() * scale_factor

				if encounter_index == current_encounter_index and battle_index == current_battle_index:
					enemy_node.texture = npc.end_screen_image_alive
					enemy_node.material = null

				npc.queue_free()
				container.add_child(enemy_node)

				# possibly do this on a delay
				enemy_node.show()
				await get_tree().create_timer(0.1).timeout
				battle_index += 1

				if encounter_index == current_encounter_index and battle_index > current_battle_index:
					return
					
		encounter_index += 1
		if encounter_index > current_encounter_index:
			return

func _clear_run_results() -> void:
	for child in results_container.get_children():
		results_container.remove_child(child)
		child.queue_free()

# Listeners

func _input(event: InputEvent) -> void:
	if !_is_showing_message:
		return

	if event.is_action_released("ui_accept"):
		hide_message()

func _on_next_run_button_pressed() -> void:
	Globals.start_next_run()

func _on_mute_button_toggled(toggled_on: bool) -> void:
	var bus_index := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, toggled_on)
