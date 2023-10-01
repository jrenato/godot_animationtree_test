class_name StateFactory

var states : Dictionary


func _init() -> void:
	states = {
		"idle": IdleState,
		"move": MoveState,
		"jump": JumpState,
		"fall": FallState,
		"attack": AttackState,
		"jump_attack": JumpAttackState,
	}


func get_state(state_name: String) -> GDScript:
	if states.has(state_name):
		return states.get(state_name)
	return states.get("idle")
