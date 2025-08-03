class_name GUIComponent extends Control

@onready var hp_bar: ProgressBar = $ProgressBar
@onready var hp_label: Label = $HPLabel
@onready var name_label: Label = $NameLabel

var max_hp: int

func setup(current_hp: int, _max_hp: int, name: String):
	max_hp = _max_hp
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp
	hp_label.text = "HP: " + str(current_hp) + "/" + str(max_hp)
	name_label.text = name

func update_hp(_amount: int, total: int):
	# TODO: could animate to this value here
	hp_bar.value = total
	hp_label.text = "HP: " + str(total) + "/" + str(max_hp)

func toggle_action_menu(state: bool):
	$ActionUIComponent.visible = state
