class_name Roll extends Action

func _ready() -> void:
	action_name = 'Roll'
	tooltip = 'Taunt the enemy by rolling in place. Has no effect.'
	default_target = DefaultActionTarget.SELF

func execute(source: Character, _target: Character) -> void:
	source.roll()
