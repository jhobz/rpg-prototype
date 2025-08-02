class_name HPComponent extends Component

@export var max_hp: int = 30

signal hp_changed(amount: int, current_hp: int)
signal hp_reached_zero()

var hp: int

func _ready() -> void:
    hp = max_hp

func change_hp(amount: int):
    hp = max(0, hp + amount)
    hp_changed.emit(amount, hp)
    if (hp <= 0):
        hp_reached_zero.emit()