class_name Dead extends Action

func _ready() -> void:
	action_name = 'Dead'
	tooltip = 'Take no action, because you are dead.'
	default_target = DefaultActionTarget.NONE
	Globals.dead_action = self
