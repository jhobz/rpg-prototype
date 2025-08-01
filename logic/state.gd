class_name State extends Node

var is_active: bool = false
var time_active: float = 0

func enter():
	pass
	
func exit():
	pass
	
func process(_delta: float) -> State:
	return null
