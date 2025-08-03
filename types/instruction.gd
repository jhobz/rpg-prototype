class_name Instruction extends RefCounted

var action: Action
var source: Character
var target: Character

func _init(a: Action, s: Character, t: Character) -> void:
    action = a
    source = s
    target = t