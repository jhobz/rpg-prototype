class_name Spell extends Action

@export var spell_element: String
@export var base_dmg: int = 0

func _ready() -> void:
	action_name = 'Spell'

func execute(source: Character, target: Character):
	var damage = base_dmg * source.magic
	target.take_damage(damage)
