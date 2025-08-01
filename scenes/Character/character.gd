class_name Character
extends Node2D

@export var animated_sprite: AnimatedSprite2D
@export var char_name: String = ""
@export var is_player_character: bool = false

@export_group("Stats")
@export var max_hp: int = 30
@export var strength: int = 5
@export var magic: int = 5
@export var defense: int = 5
@export var magic_defense: int = 5

@onready var hp: int = max_hp
var last_hp: int = 0
var is_queued_for_death := false

@export_group("Actions")
@export var available_actions: Array[Action] = []

var is_turn_active: bool = false
var is_turn_complete: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.animation_finished.connect(_on_animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if !animated_sprite.is_playing():
		animated_sprite.play('idle')
	
	if hp != last_hp:
		last_hp = hp
		$Label.text = char_name + "\n" + ("Swoon" if is_dead() else "HP: " + str(hp))

func is_dead():
	return hp <= 0

func execute_action(action: Action, target: Character):
	if not is_turn_active:
		return
	action.execute(self, target)
	is_turn_complete = true
	
func take_damage(amount: int):
	if is_dead():
		return

	animated_sprite.play('hit')
	hp -= amount

	if is_dead():
		hp = 0
		die()

func roll():
	animated_sprite.play('roll')

func _on_animation_finished():
	if !is_queued_for_death and animated_sprite.animation != 'death':
		return

	print(char_name + ' died')
	queue_free()

func die():
	if animated_sprite.is_playing() and animated_sprite.animation == 'hit':
		is_queued_for_death = true
	else:
		animated_sprite.play('death')
