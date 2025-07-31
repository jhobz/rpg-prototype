class_name Attack extends Action

@export var base_dmg: int = 0

func execute(source: Character, target: Character) -> void:
	var damage = base_dmg + source.strength
	target.take_damage(damage)
