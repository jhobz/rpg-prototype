class_name InstructionsUIManager extends Control

@onready var grid: GridContainer = $PanelContainer/ScrollContainer/VBoxContainer/MarginContainer/GridContainer

func add_instruction(instruction: Instruction):
	var source_name = instruction.source.char_name
	var action_name = instruction.action.action_name

	var source_label = grid.get_node('Source').duplicate()
	var uses_label = grid.get_node('Label').duplicate()
	var action_btn: MenuButton = grid.get_node('Action').duplicate()
	source_label.text = source_name
	uses_label.text = 'uses'
	action_btn.text = action_name
	populate_menu_items(action_btn, instruction)
	grid.add_child(source_label)
	grid.add_child(uses_label)
	grid.add_child(action_btn)
	source_label.visible = true
	uses_label.visible = true
	action_btn.visible = true
	action_btn.get_popup().index_pressed.connect(_on_popup_window_index_pressed.bind(instruction, action_btn))

func populate_menu_items(btn: MenuButton, instruction: Instruction) -> void:
	var popup: PopupMenu = btn.get_popup()
	var items = []
	popup.clear()
	items.append_array(instruction.source.available_actions.map(func(a): return a.action_name))

	for item in items:
		popup.add_item(item)

func replace_instruction_at_index(index: int, instruction: Instruction) -> void:
	print('index', index)
	# there are 3 ui items per instruction, +3 nodes for positioning, +2 to get to action
	var i := index * 3 + 3 + 2
	var ui_items = grid.get_children()
	print('size', ui_items.size())
	print(ui_items[i])
	ui_items[i].text = instruction.action.action_name

func toggle_input(state: bool):
	var value = Control.MOUSE_FILTER_PASS if state else Control.MOUSE_FILTER_IGNORE
	self.propagate_call("set_mouse_filter", [value])
	# self.propagate_call('mouse_default_cursor_shape', [Control.CURSOR_ARROW if state else Control.CURSOR_FORBIDDEN])

#region Listeners

func _on_popup_window_index_pressed(index: int, instruction: Instruction, btn: MenuButton) -> void:
	var new_action = instruction.source.available_actions[index]
	instruction.action = new_action
	instruction.target = null
	btn.text = new_action.action_name

#endregion
