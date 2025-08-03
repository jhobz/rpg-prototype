extends State

func enter():
	%Status.text = "You've done it! All of the enemies have been defeated forever!"
	%StatusContainer.visible = true
	
func exit():
	%StatusContainer.visible = false
	
func process(_delta: float) -> State:
	return null
