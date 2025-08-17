extends State

@export var battle_idle_state: State
@export var encounter_complete_state: State
@export var instruction_tutorial_state: State

@onready var players: CharacterGroup = %Characters/Players
@onready var enemies: CharacterGroup = %Characters/Enemies
@onready var game_manager: GameManager = %GameManager
@onready var ui_manager: UIManager = %UI

var _encounter: Encounter
var _next_battle := 0
var _has_advanced_dialogue := false

func init(encounter: Encounter):
	_encounter = encounter
	_next_battle = 0
	battle_idle_state.reset_turn()

func enter():
	Globals.dialogue_completed.connect(_on_dialogue_completed)

	if _next_battle < _encounter.battles.size():
		_has_advanced_dialogue = false
		ui_manager.queue_message("An enemy is approaching!", 1)

func exit():
	Globals.dialogue_completed.disconnect(_on_dialogue_completed)
	
func process(_delta: float) -> State:
	if _next_battle >= _encounter.battles.size():
		return encounter_complete_state
		
	if !_has_advanced_dialogue:
		return null
		
	enemies.clear()
	var battle = _encounter.battles[_next_battle]
	assert(battle.enemies.size() == 1)
	
	var enemy: Node2D = battle.enemies[0].instantiate()
	enemies.add_character(enemy)
	game_manager.current_enemy = enemy
	enemy.position = %DummyEnemy.position
	battle_idle_state.init()

	Globals.start_battle(_next_battle)
	_next_battle += 1

	if Globals.save_state.current_encounter_index == 2 and !Globals.save_state.has_seen_instruction_tutorial:
		return instruction_tutorial_state

	return battle_idle_state

func _on_dialogue_completed():
	_has_advanced_dialogue = true
