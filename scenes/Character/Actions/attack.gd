class_name Attack extends Action

@export var base_dmg: int = 0

func _ready() -> void:
	action_name = 'Attack'
	tooltip = 'Strike the enemy for 10 physical damage.'

func execute(source: Character, target: Character) -> void:
	var damage = base_dmg * source.get_stat('strength') / max(1, target.get_stat('defense'))
	target.take_damage(damage)
