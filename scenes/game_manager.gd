extends Node

@onready var actions: Node = %Actions
@onready var characters: Node = %Characters
@onready var state_machine: StateMachine = %GameStateMachine
@onready var john: Character = %Characters/JohnRPG

func _ready() -> void:
	state_machine.init_state_machine()
	
func _process(delta: float):
	state_machine.process_state_machine(delta)

func _on_attack_top_button_pressed() -> void:
	if not john.is_turn_active:
		return
	var attack = actions.get_node("Attack")
	var top = characters.get_node("TopGuy")
	john.execute_action(attack, top)
	
func _on_attack_bottom_button_pressed() -> void:
	if not john.is_turn_active:
		return
	var attack = actions.get_node("Attack")
	var bottom = characters.get_node("BottomGuy")
	john.execute_action(attack, bottom)

func _on_roll_button_pressed() -> void:
	if not john.is_turn_active:
		return
	var roll = actions.get_node("Roll")
	john.execute_action(roll, john)
