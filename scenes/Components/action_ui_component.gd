class_name ActionUIComponent extends Control

@export var actor: Character

@onready var game_manager: GameManager = %GameManager
@onready var container := $PanelContainer/VBoxContainer

signal action_selected(action: Action, source: Character)

var actions: Array[Action]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_clear()

	actions = actor.available_actions
	for action in actions:
		var action_name = action.action_name
		var button := Button.new()
		button.text = action_name
		button.pressed.connect(_button_pressed.bind(action))
		container.add_child(button)

func _clear():
	var old_buttons = container.get_children()
	for button in old_buttons:
		container.remove_child(button)

func _button_pressed(action: Action):
	print('trying to execute action ' + action.action_name + ' from ' + actor.char_name + ' on ' + game_manager.current_enemy.char_name)
	action_selected.emit(action, actor)
	# action.execute(actor, game_manager.current_enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if actor.is_turn_active != visible:
		visible = actor.is_turn_active
