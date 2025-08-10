extends State

@onready var ui_manager: UIManager = %UI

func enter():
	ui_manager.show_message("You've done it! All of the enemies have been defeated forever!")

func exit():
	ui_manager.hide_message()
	
func process(_delta: float) -> State:
	return null
