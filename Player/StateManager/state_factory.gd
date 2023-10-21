class_name StateFactory

var states : Dictionary


func _init() -> void:
	states = {
		"idle": IdleState,
		"walk": WalkState,
		"run": RunState,

		"jump": JumpState,
		"fall": FallState,
		"jump_attack": JumpAttackState,

		"dash": DashState,
		"dash_spin_attack": DashSpinAttackState,

		"attack": AttackState,
		"shoot": ShootState,
		"cast": CastState,

		"block": BlockState,
	}


func get_state(state_name: String) -> GDScript:
	if states.has(state_name):
		return states.get(state_name)
	return states.get("idle")
