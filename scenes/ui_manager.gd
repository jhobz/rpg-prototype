extends MarginContainer
class_name UIManager

@onready var instructions_control: InstructionsUIManager = %Instructions
@onready var status_container: CenterContainer = %StatusContainer
@onready var status_label: Label = %Status
@onready var run_results_panel: VBoxContainer = %RunResultsPanel

func _ready() -> void:
	print_debug('UIManager ready')

# Instructions

func add_instruction(instruction: Instruction) -> void:
	instructions_control.add_instruction(instruction)

func replace_instruction_at_index(index: int, instruction: Instruction) -> void:
	instructions_control.replace_instruction_at_index(index, instruction)

func set_instructions_input_enabled(enabled: bool) -> void:
	instructions_control.toggle_input(enabled)

func set_active_instruction(index: int) -> void:
	instructions_control.set_active_instruction(index)

# Messages

func show_message(message: String) -> void:
	status_label.text = message
	status_container.show()

func hide_message() -> void:
	status_container.hide()

func set_message_position(pos: String) -> void:
	match pos:
		"center":
			status_container.size_flags_vertical = Control.SizeFlags.SIZE_FILL
		"top":
			status_container.size_flags_vertical = Control.SizeFlags.SIZE_SHRINK_BEGIN

# Run results

func show_run_results() -> void:
	run_results_panel.show()

func hide_run_results() -> void:
	run_results_panel.hide()

# Listeners

func _on_next_run_button_pressed() -> void:
	Globals.start_next_run()
