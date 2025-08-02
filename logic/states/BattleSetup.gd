extends State

@export var battle_idle_state: State = null
@export var encounter_complete_state: State = null

var encounter: Encounter = null
var next_battle: int = 0

func init(_encounter: Encounter):
	encounter = _encounter
	next_battle = 0

func enter():
	if next_battle < encounter.battles.size():
		%Status.text = "An enemy is approaching!"
		%Status.visible = true
	
func exit():
	%Status.visible = false
	pass
	
func process(_delta: float) -> State:
	if next_battle >= encounter.battles.size():
		return encounter_complete_state
		
	# whee artificial delays, let's pretend it's for "loading"
	if time_active < 1:
		return null
		
	var prev_enemies = %Characters/Enemies.get_children()
	for enemy in prev_enemies:
		%Characters/Enemies.remove_child(enemy)
		enemy.queue_free()
	
	var battle = encounter.battles[next_battle]
	assert(battle.enemies.size() == 1)
	
	var enemy: Node2D = battle.enemies[0].instantiate()
	%Characters/Enemies.add_child(enemy)
	%GameManager.current_enemy = enemy.get_node("Character")
	enemy.position = Vector2(-69, -274)
	
	next_battle += 1
	battle_idle_state.init()
	return battle_idle_state
