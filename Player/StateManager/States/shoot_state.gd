class_name ShootState extends State

const AIM_MAX_SPEED: float = 4.0
const AIM_ACCELERATION: float = 10.0

var player : Player


func _ready() -> void:
	player = get_parent()


func _process(delta: float) -> void:
	if not player.can_shoot() or not player.is_attacking:
		player.change_state("idle")

	if not player.is_on_floor():
		player.change_state("fall")

	if player.is_attacking and player.can_shoot():
		player.update_locked_direction()
#		if not player.is_reloading() and not player.animation_tree["parameters/MoveBlockAimOneShot/active"]:
#			player.shoot()


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, player.direction.x * AIM_MAX_SPEED, AIM_ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, player.direction.z * AIM_MAX_SPEED, AIM_ACCELERATION * delta)


func _on_footstep(foot: String) -> void:
	if not player.walk_dust_particles.emitting:
		player.walk_dust_particles.emitting = true
