class_name Spell extends Action

@export var spell_element: String
@export var base_dmg: int = 0

func _ready() -> void:
	action_name = 'Spell'
	tooltip = 'Cast a spell at the enemy, dealing 10 magic damage.'

func execute(source: Character, target: Character):
	var damage = base_dmg * source.get_stat('magic') / max(1, target.get_stat('magic_defense'))
	target.take_damage(damage)
