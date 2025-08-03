class_name Cleave extends Action

@export var base_dmg: int = 0

func _ready() -> void:
	action_name = 'Cleave'

func execute(source: Character, target: Character) -> void:
	for character in target.character_group.characters:
		var damage = base_dmg * source.get_stat('strength') / max(1, target.get_stat('defense'))
		character.take_damage(damage)
