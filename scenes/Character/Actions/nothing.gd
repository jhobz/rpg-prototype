class_name Nothing extends Action

func _ready() -> void:
	action_name = 'No Action'
	tooltip = 'Take no action.'
	default_target = Action.DefaultActionTarget.NONE
	Globals.nothing_action = self
