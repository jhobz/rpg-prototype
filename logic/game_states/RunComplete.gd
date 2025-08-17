extends State

var _has_advanced_dialogue := false

@onready var ui_manager: UIManager = %UI

func enter():
	Globals.dialogue_completed.connect(on_dialogue_completed)
	_has_advanced_dialogue = false
	DialogueManager.play_victory_dialogue()

func exit():
	Globals.dialogue_completed.disconnect(on_dialogue_completed)
	
func process(_delta: float) -> State:
	return null

func on_dialogue_completed():
	_has_advanced_dialogue = true
