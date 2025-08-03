extends State

@export var battle_idle_state: State
@export var encounter_complete_state: State

@onready var players: CharacterGroup = %Characters/Players
@onready var enemies: CharacterGroup = %Characters/Enemies
@onready var game_manager: GameManager = %GameManager

var encounter: Encounter
var next_battle := 0

func init(_encounter: Encounter):
	encounter = _encounter
	next_battle = 0
	battle_idle_state.reset_turn()

func enter():
	if next_battle < encounter.battles.size():
		%Status.text = "An enemy is approaching!"
		%StatusContainer.visible = true
	
func exit():
	%StatusContainer.visible = false
	pass
	
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
	enemy.position = Vector2(96, -90)
	
	next_battle += 1
	battle_idle_state.init()
	return battle_idle_state
