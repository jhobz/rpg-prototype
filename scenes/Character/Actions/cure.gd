class_name Cure extends Action

@export var base_heal: int = 4

func _ready() -> void:
	action_name = 'Cure'
	default_target = DefaultActionTarget.SELF

func execute(source: Character, target: Character):
	var heal = base_heal * source.get_stat('magic')
	for character in target.character_group.characters:
		character.take_damage(-heal)
