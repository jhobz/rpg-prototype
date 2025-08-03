class_name AIComponent extends Component

func _ready() -> void:
	pass

func select_action() -> Action:
	return

func select_target() -> Character:
	var players: Array[Character] = CharacterManager.player_characters
	var highest_hp := -1
	var target: Character

	for player in players:
		if player.hp_component.hp > highest_hp:
			highest_hp = player.hp_component.hp

			target = player
	
	return target
