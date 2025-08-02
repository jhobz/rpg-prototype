extends State

func enter():
	%Status.text = "You've done it! All of the enemies have been defeated forever!"
	%Status.visible = true
	
func exit():
	%Status.visible = false
	
func process(_delta: float) -> State:
	return null
