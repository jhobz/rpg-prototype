extends State

var _has_advanced_dialogue := false

@onready var ui_manager: UIManager = %UI

func enter():
	Globals.dialogue_completed.connect(on_dialogue_completed)
	_has_advanced_dialogue = false
	ui_manager.queue_message("You've done it! All of the enemies have been defeated forever!")

func exit():
	Globals.dialogue_completed.disconnect(on_dialogue_completed)
	
func process(_delta: float) -> State:
	return null

func on_dialogue_completed():
	_has_advanced_dialogue = true
