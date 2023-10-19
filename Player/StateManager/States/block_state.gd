class_name BlockState extends State

const BASH_MAX_SPEED: float = 5.0
const BASH_ACCELERATION: float = 12.0

var player : Player
var bash_direction: Vector3
var is_bashing: bool = false


func _ready() -> void:
	player = get_parent()
	player.animation_tree["parameters/MoveBlockAimOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func _process(delta: float) -> void:
	if not is_bashing:
		player.update_locked_direction()

	if is_bashing and player.animation_tree["parameters/BlockAimStateMachine/playback"].get_current_node() != "Bash Attack":
		is_bashing = false

	if not player.is_holding_secondary_action and not is_bashing:
		player.change_state("idle")

	if not player.is_on_floor():
		player.change_state("fall")

	if player.is_attacking and player.can_bash_attack():
		is_bashing = true
		bash_direction = player.player_mesh.basis.z
		player.bash_recharge_timer.start()


func _physics_process(delta: float) -> void:
	if not is_bashing:
		player.velocity.x = move_toward(player.velocity.x, player.direction.x * player.MAX_SPEED, player.ACCELERATION * delta)
		player.velocity.z = move_toward(player.velocity.z, player.direction.z * player.MAX_SPEED, player.ACCELERATION * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, bash_direction.x * BASH_MAX_SPEED, BASH_ACCELERATION * delta)
		player.velocity.z = move_toward(player.velocity.z, bash_direction.z * BASH_MAX_SPEED, BASH_ACCELERATION * delta)


func _on_footstep(foot: String) -> void:
	if not player.walk_dust_particles.emitting:
		player.walk_dust_particles.emitting = true
