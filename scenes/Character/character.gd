class_name Character
extends Node2D

# @export var animated_sprite: AnimatedSprite2D
@export var char_name: String = ""

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gui_component: GUIComponent = $GUIComponent
@onready var hp_component: HPComponent = $HPComponent
@onready var stats_component: StatsComponent = $StatsComponent

var is_player_character: bool = false

# @export_group("Stats")
# @export var max_hp: int = 30
# @export var strength: int = 5
# @export var magic: int = 5
# @export var defense: int = 5
# @export var magic_defense: int = 5

# @onready var hp: int = max_hp
var last_hp: int = 0
var is_queued_for_death := false

# @export_group("Actions")
# @export var available_actions: Array[Action] = []

var is_turn_active: bool = false
var is_turn_complete: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(hp_component)
	assert(stats_component)
	assert(animated_sprite)
	assert(gui_component)
	animated_sprite.animation_finished.connect(_on_animation_finished)
	hp_component.hp_changed.connect(_on_hp_changed)
	hp_component.hp_reached_zero.connect(_on_hp_reached_zero)
	gui_component.setup(hp_component.max_hp, hp_component.max_hp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if !animated_sprite.is_playing():
		animated_sprite.play('idle')

func start_turn():
	is_turn_active = true
	is_turn_complete = false

func end_turn():
	is_turn_active = false

func get_stat(type: String):
	return stats_component[type]

func is_dead():
	return hp_component.hp <= 0

func execute_action(action: Action, target: Character):
	if not is_turn_active:
		return
	action.execute(self, target)
	is_turn_complete = true
	
func take_damage(amount: int):
	if is_dead():
		return

	animated_sprite.play('hit')
	hp_component.change_hp(-1 * amount)

func roll():
	animated_sprite.play('roll')

func die():
	if animated_sprite.is_playing() and animated_sprite.animation == 'hit':
		is_queued_for_death = true
	else:
		animated_sprite.play('death')


#region Listeners

func _on_animation_finished():
	if !is_queued_for_death and animated_sprite.animation != 'death':
		return

	print(char_name + ' died')
	visible = false

func _on_hp_changed(amount: int, current_hp: int):
	gui_component.update_hp(amount, current_hp)

func _on_hp_reached_zero():
	die()

#endregion