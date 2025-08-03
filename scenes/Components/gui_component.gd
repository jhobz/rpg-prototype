class_name GUIComponent extends Control

@onready var hp_bar: ProgressBar = $ProgressBar

func setup(current_hp: int, max_hp: int):
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp

func update_hp(_amount: int, total: int):
	# TODO: could animate to this value here
	hp_bar.value = total

func toggle_action_menu(state: bool):
	$ActionUIComponent.visible = state
