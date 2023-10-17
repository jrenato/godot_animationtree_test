class_name BlockState extends State

var player : Player


func _ready() -> void:
	player = get_parent()
	player.animation_tree["parameters/MoveBlockAimOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func _process(delta: float) -> void:
	# Use this only if testing direction lock with the mouse
	if player.target_look_position:
		player.player_mesh.look_at(player.target_look_position, Vector3(0, 1, 0), true)

	player.player_mesh.rotation.x = 0.0
	player.player_mesh.rotation.z = 0.0

	if not player.is_holding_secondary_action:
		player.change_state("idle")

	if not player.is_on_floor():
		player.change_state("fall")

	if player.is_attacking:
		# TODO: Implement BashAttack
		pass


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, player.direction.x * player.MAX_SPEED, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, player.direction.z * player.MAX_SPEED, player.ACCELERATION * delta)


func _on_footstep(foot: String) -> void:
	if not player.walk_dust_particles.emitting:
		player.walk_dust_particles.emitting = true
