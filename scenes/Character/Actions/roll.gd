class_name Roll extends Action

func _ready() -> void:
	action_name = 'Roll'

func execute(source: Character, _target: Character) -> void:
	source.roll()
