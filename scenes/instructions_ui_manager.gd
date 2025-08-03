extends Control

@onready var grid: GridContainer = $PanelContainer/ScrollContainer/VBoxContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_instruction(instruction: Instruction):
	var source_name = instruction.source.char_name
	var action_name = instruction.action.action_name

	# var source_btn = MenuButton.new()
	var source_btn = grid.get_node('SourceBtn').duplicate()
	# var uses_label = Label.new()
	var uses_label = grid.get_node('Label').duplicate()
	# var action_btn = MenuButton.new()
	var action_btn = grid.get_node('ActionBtn').duplicate()
	source_btn.text = source_name
	uses_label.text = 'uses'
	action_btn.text = action_name
	grid.add_child(source_btn)
	grid.add_child(uses_label)
	grid.add_child(action_btn)
	source_btn.visible = true
	uses_label.visible = true
	action_btn.visible = true
	source_btn.about_to_popup.connect(_on_menu_btn_about_to_popup.bind(source_btn, instruction, 'source'))
	action_btn.about_to_popup.connect(_on_menu_btn_about_to_popup.bind(action_btn, instruction, 'action'))

func _on_menu_btn_about_to_popup(btn: MenuButton, instruction: Instruction, type: String) -> void:
	var popup = btn.get_popup()
	var gm = Globals.game_manager

	var items = []

	match type:
		'source':
			items.append_array(gm.player_characters.map(func(c): return c.char_name))
		'action':
			items.append_array(instruction.source.available_actions.map(func(a): return a.action_name))
		# 'target':
		# 	items.append_array(gm.player_characters.map(func(c): return c.char_name))
		# 	items.append('Enemy')
	popup.clear()
	for item in items:
		popup.add_item(item)
