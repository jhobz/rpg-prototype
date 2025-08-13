class_name InstructionsUIManager extends Control

@onready var grid: GridContainer = $PanelContainer/ScrollContainer/VBoxContainer/MarginContainer/GridContainer
@onready var scroll_container = $PanelContainer/ScrollContainer

var active_instruction: int = -1
var last_instruction: int = -1

func _process(_delta: float) -> void:
	if active_instruction != last_instruction:
		update_active_instruction()
		last_instruction = active_instruction

func add_instruction(instruction: Instruction):
	var source_name = instruction.source.char_name
	var action_name = instruction.action.action_name

	var indicator = grid.get_node('Indicator').duplicate()
	var source_label = grid.get_node('Source').duplicate()
	var uses_label = grid.get_node('Label').duplicate()
	var action_btn: MenuButton = grid.get_node('Action').duplicate()
	source_label.text = source_name
	uses_label.text = 'uses'
	action_btn.text = action_name
	action_btn.set_tooltip_text(instruction.action.tooltip)
	populate_menu_items(action_btn, instruction)
	grid.add_child(indicator)
	grid.add_child(source_label)
	grid.add_child(uses_label)
	grid.add_child(action_btn)
	indicator.visible = true
	source_label.visible = true
	uses_label.visible = true
	action_btn.visible = true
	action_btn.get_popup().index_pressed.connect(_on_popup_window_index_pressed.bind(instruction, action_btn))

func populate_menu_items(btn: MenuButton, instruction: Instruction) -> void:
	var popup: PopupMenu = btn.get_popup()
	popup.clear()

	var index := 0
	for action in instruction.source.available_actions:
		popup.add_item(action.action_name)
		popup.set_item_tooltip(index, action.tooltip)
		index += 1

func replace_instruction_at_index(index: int, instruction: Instruction) -> void:
	# there are 4 ui items per instruction, +4 nodes for positioning, +3 to get to action
	var i := index * 4 + 4 + 3
	var ui_items = grid.get_children()
	ui_items[i].text = instruction.action.action_name
	ui_items[i].set_tooltip_text(instruction.action.tooltip)

func toggle_input(state: bool):
	var value = Control.MOUSE_FILTER_PASS if state else Control.MOUSE_FILTER_IGNORE
	self.propagate_call("set_mouse_filter", [value])
	# self.propagate_call('mouse_default_cursor_shape', [Control.CURSOR_ARROW if state else Control.CURSOR_FORBIDDEN])
	
func update_active_instruction():
	var ui_items = grid.get_children()
	
	# there are 4 ui items per instruction, +4 nodes for positioning
	if last_instruction >= 0:
		var i := last_instruction * 4 + 4
		ui_items[i].get_node("Texture").visible = false
	
	if active_instruction >= 0:
		var i = active_instruction * 4 + 4
		ui_items[i].get_node("Texture").visible = true
		# update scrollbar position
		var scrollbar = scroll_container.get_v_scroll_bar()
		var ratio = float(i - 4) / (ui_items.size() - 4) / 4
		var tween = get_tree().create_tween()
		tween.tween_property(scrollbar, "ratio", ratio, 0.15).set_trans(Tween.TRANS_QUAD)

func set_active_instruction(index: int):
	active_instruction = index

#region Listeners

func _on_popup_window_index_pressed(index: int, instruction: Instruction, btn: MenuButton) -> void:
	var new_action = instruction.source.available_actions[index]
	instruction.action = new_action
	instruction.target = null
	btn.text = new_action.action_name
	btn.set_tooltip_text(new_action.tooltip)

#endregion
