class_name Character
extends Node2D

@export var char_name := "Character"
@export var hit_sfx: AudioStream
@export var death_sfx: AudioStream

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var gui_component: GUIComponent = $GUIComponent
@onready var hp_component: HPComponent = $HPComponent
@onready var stats_component: StatsComponent = $StatsComponent

var character_group: CharacterGroup

var is_player_character := false
var is_turn_active := false
var is_turn_complete := false

var _is_queued_for_death := false

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(animated_sprite)
	assert(audio_player)
	assert(gui_component)
	assert(hp_component)
	assert(stats_component)

	animated_sprite.animation_finished.connect(_on_animation_finished)
	hp_component.hp_changed.connect(_on_hp_changed)
	hp_component.hp_reached_zero.connect(_on_hp_reached_zero)
	gui_component.setup(hp_component.max_hp, hp_component.max_hp, char_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	pass
	if !animated_sprite.is_playing():
		animated_sprite.play('idle')

func get_stat(type: String):
	return stats_component[type]

func is_dead():
	return hp_component.hp <= 0
	
func refill_hp():
	hp_component.change_hp(hp_component.max_hp)

func execute_action(action: Action, target: Character):
	if not is_turn_active:
		return
	action.execute(self, target)


#region Actions
	
func take_damage(amount: int):
	if is_dead():
		return
	hp_component.change_hp(-1 * amount)

func roll():
	print("stunt on 'em, kid")
	pass

func die():
	if animated_sprite.is_playing() and animated_sprite.animation == 'hit':
		_is_queued_for_death = true
	else:
		animated_sprite.play('death')
		play_death_sfx()

func play_hit_sfx():
	if hit_sfx:
		audio_player.set_stream(hit_sfx)
		audio_player.play()

func play_action_sfx(action: Action):
	if action.sfx:
		audio_player.set_stream(action.sfx)
		audio_player.play()

func play_death_sfx():
	if death_sfx:
		audio_player.set_stream(death_sfx)
		audio_player.play()

#endregion


#region Listeners

func _on_animation_finished():
	# this is a lazy patch for the fact that the turn state machine executes the
	# action (which causes fatal damage, triggering the death animation) but
	# then immediately forces a hit animation
	if is_dead() and animated_sprite.animation == 'hit':
		animated_sprite.play('death')
		play_death_sfx()
		return
	if !_is_queued_for_death and animated_sprite.animation != 'death':
		return

	visible = false

func _on_hp_changed(amount: int, current_hp: int):
	gui_component.update_hp(amount, current_hp)

func _on_hp_reached_zero():
	die()

#endregion
