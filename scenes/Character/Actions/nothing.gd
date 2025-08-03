class_name Nothing extends Action

func _ready() -> void:
	action_name = 'No Action'
	Globals.nothing_action = self

func execute(source: Character, target: Character) -> void:
	pass
