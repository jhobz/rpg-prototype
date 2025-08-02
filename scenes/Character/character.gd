class_name Character
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
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
var is_taking_damage := false
var is_dead := false

@export_group("Actions")
@export var available_actions: Array[Action] = []

var is_turn_active: bool = false
var is_turn_complete: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print('an animation finished: ' + anim_name)
	match anim_name:
		'hit':
			# is_taking_damage = false
			pass
		'die':
			print(char_name + ' died')
			visible = false
		'attack':
			print('i just attacked')

	is_turn_complete = true

func start_turn():
	is_turn_active = true
	is_turn_complete = false

func end_turn():
	is_turn_active = false

func execute_action(action: Action, target: Character):
	if !is_turn_active:
		return

	if action.action_name == 'Attack':
		animation_player.queue('attack')

	action.execute(self, target)
	
func take_damage(amount: int):
	is_taking_damage = true
	# if is_dead:
	# 	return

	# animated_sprite.play('hit')
	hp -= amount

	if hp <= 0:
		hp = 0
		die()
	
	is_taking_damage = false

func roll():
	animation_player.play('roll')

func die():
	is_taking_damage = false
	is_dead = true
	# if animated_sprite.is_playing() and animated_sprite.animation == 'hit':
	# 	is_queued_for_death = true
	# else:
	# 	animated_sprite.play('death')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	# if !animated_sprite.is_playing():
	# 	animated_sprite.play('idle')
	if hp != last_hp:
		last_hp = hp
		$Label.text = char_name + "\n" + ("Swoon" if is_dead else "HP: " + str(hp))
