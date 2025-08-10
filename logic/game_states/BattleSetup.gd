extends State

@export var battle_idle_state: State
@export var encounter_complete_state: State

@onready var players: CharacterGroup = %Characters/Players
@onready var enemies: CharacterGroup = %Characters/Enemies
@onready var game_manager: GameManager = %GameManager
@onready var ui_manager: UIManager = %UI

var encounter: Encounter
var next_battle := 0

func init(_encounter: Encounter):
	encounter = _encounter
	next_battle = 0
	battle_idle_state.reset_turn()

func enter():
	if next_battle < encounter.battles.size():
		ui_manager.show_message("An enemy is approaching!")

func exit():
	ui_manager.hide_message()
	
func process(_delta: float) -> State:
	if next_battle >= encounter.battles.size():
		return encounter_complete_state
		
	# whee artificial delays, let's pretend it's for "loading"
	if time_active < 1:
		return null
		
	enemies.clear()
	var battle = encounter.battles[next_battle]
	assert(battle.enemies.size() == 1)
	
	var enemy: Node2D = battle.enemies[0].instantiate()
	enemies.add_character(enemy)
	game_manager.current_enemy = enemy
	enemy.position = %DummyEnemy.position
	
	next_battle += 1
	battle_idle_state.init()
	return battle_idle_state
