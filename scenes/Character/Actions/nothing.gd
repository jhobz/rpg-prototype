class_name Nothing extends Action

func _ready() -> void:
	action_name = 'No Action'
	default_target = Action.DefaultActionTarget.SELF
	Globals.nothing_action = self
