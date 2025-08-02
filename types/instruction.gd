class_name Instruction extends RefCounted

var action: Action
var source: Character
var target: Character

func _init(a, s, t) -> void:
    action = a
    source = s
    target = t