extends Control

@onready var grid: GridContainer = $PanelContainer/ScrollContainer/VBoxContainer/GridContainer

func add_instruction(instruction: Instruction):
	var source_name = instruction.source.char_name
	var action_name = instruction.action.action_name

	var source_label = grid.get_node('Source').duplicate()
	var uses_label = grid.get_node('Label').duplicate()
	var action_btn = grid.get_node('Action').duplicate()
	source_label.text = source_name
	uses_label.text = 'uses'
	action_btn.text = action_name
	grid.add_child(source_label)
	grid.add_child(uses_label)
	grid.add_child(action_btn)
	source_label.visible = true
	uses_label.visible = true
	action_btn.visible = true
	action_btn.about_to_popup.connect(_on_menu_btn_about_to_popup.bind(action_btn, instruction))

func _on_menu_btn_about_to_popup(btn: MenuButton, instruction: Instruction) -> void:
	var popup: PopupMenu = btn.get_popup()

	var items = []
	items.append_array(instruction.source.available_actions.map(func(a): return a.action_name))

	popup.clear()
	for item in items:
		popup.add_item(item)

	popup.index_pressed.connect(_on_popup_window_index_pressed.bind(instruction, btn))

func _on_popup_window_index_pressed(index: int, instruction: Instruction, btn: MenuButton) -> void:
	var new_action = instruction.source.available_actions[index]
	instruction.action = new_action
	btn.text = new_action.action_name
