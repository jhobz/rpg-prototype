extends State

func enter() -> void:
    super.enter()

func exit() -> void:
    super.exit()

func process(_delta: float) -> State:
    # hang out waiting for state to be changed elsewhere
    return