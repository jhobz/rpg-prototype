class_name ActionUIComponent extends Control

@export var actor: PlayerCharacter

@onready var container := $PanelContainer/VBoxContainer

signal action_selected(action: Action, source: Character)

var actions: Array[Action]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_clear_buttons()
	actor.action_added.connect(_on_actor_action_added)

func _clear_buttons():
	var old_buttons = container.get_children()
	for button in old_buttons:
		container.remove_child(button)

func _add_button(action: Action):
	var button := Button.new()
	button.text = action.action_name
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.pressed.connect(_button_pressed.bind(action))
	button.set_tooltip_text(action.tooltip)
	container.add_child(button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !actor.is_turn_active:
		visible = false


#region Listeners

func _button_pressed(action: Action):
	action_selected.emit(action, actor)

func _on_actor_action_added(action: Action):
	actions.append(action)
	_add_button(action)

#endregion
