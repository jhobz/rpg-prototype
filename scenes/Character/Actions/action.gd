class_name Action
extends Node2D

enum DefaultActionTarget {
	ENEMY,
	ENEMY_ALL,
	SELF,
}

@export var sfx: AudioStream

var action_name: String = ""
var tooltip: String = ""
var default_target: DefaultActionTarget = DefaultActionTarget.ENEMY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func execute(_source: Character, _target: Character) -> void:
	pass
