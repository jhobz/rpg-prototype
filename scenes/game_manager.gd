extends Node

@onready var actions: Node = %Actions
@onready var characters: Node = %Characters

func _on_button_pressed() -> void:
	var my_action = actions.get_node('Roll')
	var john = characters.get_node('JohnRPG')
	john.execute_action(my_action)
