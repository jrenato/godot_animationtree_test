class_name AimState extends State

const AIM_MAX_SPEED: float = 4.0
const AIM_ACCELERATION: float = 10.0

var player : Player


func _ready() -> void:
	player = get_parent()
	player.animation_tree["parameters/MoveBlockAimOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func _process(delta: float) -> void:
	player.update_locked_direction()

	if not player.is_holding_secondary_action:
		player.change_state("idle")

	if not player.is_on_floor():
		player.change_state("fall")

	if player.is_attacking:
		# TODO: Shoot!
		pass


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, player.direction.x * AIM_MAX_SPEED, AIM_ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, player.direction.z * AIM_MAX_SPEED, AIM_ACCELERATION * delta)


func _on_footstep(foot: String) -> void:
	if not player.walk_dust_particles.emitting:
		player.walk_dust_particles.emitting = true
