class_name Roll extends Action

func _ready() -> void:
	action_name = 'Roll'
	tooltip = "Has no effect. Stunt on 'em, kid."
	default_target = DefaultActionTarget.NONE

func execute(source: Character, _target: Character) -> void:
	source.roll()
