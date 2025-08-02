class_name Component extends Node

@export var actor: Node

func _ready() -> void:
    if !actor:
        actor = get_parent()