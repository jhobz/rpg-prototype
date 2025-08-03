class_name PlayerCharacter extends Character

signal action_added(action: Action)

var available_actions: Array[Action] = []

func _init() -> void:
	is_player_character = true

func _ready() -> void:
	super._ready()
	var nodes = get_node('Actions').get_children()
	for node in nodes:
		if node is Action:
			available_actions.append(node)
			action_added.emit(node)
