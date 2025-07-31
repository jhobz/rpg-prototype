class_name Character
extends Node2D

@export var available_actions: Array[Action] = []
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !animated_sprite.is_playing():
		animated_sprite.play('idle')

func execute_action(action: Action):
	if action.action_name == 'roll':
		animated_sprite.play('roll')

	action.execute() # with a target
