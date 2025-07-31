class_name Character
extends Node2D

@export var char_name: String = ""

@export_group("Stats")
@export var max_hp: int = 30
@export var strength: int = 5
@export var magic: int = 5
@export var defense: int = 5
@export var magic_defense: int = 5

@onready var hp: int = max_hp
var last_hp: int = 0

@export_group("Actions")
@export var available_actions: Array[Action] = []
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if !animated_sprite.is_playing():
		if is_dead():
			animated_sprite.hide()
		else:
			animated_sprite.play('idle')
	
	if hp != last_hp:
		last_hp = hp
		$Label.text = char_name + "\n" + ("Swoon" if is_dead() else "HP: " + str(hp))

func is_dead():
	return hp <= 0

func execute_action(action: Action, target: Character):
	if action.action_name == 'roll':
		animated_sprite.play('roll')

	action.execute(self, target)
	
func take_damage(amount: int):
	if hp <= 0:
		return
	hp -= amount
	if is_dead():
		hp = 0
		roll()
		# die

func roll():
	animated_sprite.play('roll')
