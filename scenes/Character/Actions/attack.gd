class_name Attack extends Action

@export var base_dmg: int = 0

func _ready() -> void:
	action_name = 'Attack'

func execute(source: Character, target: Character) -> void:
	var damage = base_dmg * source.get_stat('strength') / max(1, target.get_stat('defense'))
	print('making target take ' + str(damage) + ' damage')
	target.take_damage(damage)
