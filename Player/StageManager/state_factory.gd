class_name StateFactory

var states : Dictionary


func _init() -> void:
	states = {
		"idle": IdleState,
		"attack": AttackState,
		"move": MoveState,
		"jump": JumpState,
	}


func get_state(state_name: String) -> GDScript:
	if states.has(state_name):
		return states.get(state_name)
	return states.get("idle")
