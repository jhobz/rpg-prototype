extends Node

@onready var actions: Node = %Actions
@onready var characters: Node = %Characters
@onready var state_machine: StateMachine = %GameStateMachine

func _ready() -> void:
	pass

func _on_attack_top_button_pressed() -> void:
	var attack = actions.get_node("Attack")
	var john = characters.get_node("JohnRPG")
	var top = characters.get_node("TopGuy")
	attack.execute(john, top)
	
func _on_attack_bottom_button_pressed() -> void:
	var attack = actions.get_node("Attack")
	var john = characters.get_node("JohnRPG")
	var bottom = characters.get_node("BottomGuy")
	attack.execute(john, bottom)

func _on_roll_button_pressed() -> void:
	print("hello??")
	var roll = actions.get_node("Roll")
	var john = characters.get_node('JohnRPG')
	roll.execute(john, null)
