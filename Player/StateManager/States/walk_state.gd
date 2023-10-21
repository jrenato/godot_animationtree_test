class_name WalkState extends State

var player : Player


func _ready() -> void:
	player = get_parent()


func exit() -> void:
	player.walk_dust_particles.emitting = false


func _process(delta: float) -> void:
	if player.direction:
		var align = player.player_mesh.transform.looking_at(player.player_mesh.transform.origin - player.direction)
		player.player_mesh.transform = player.player_mesh.transform.interpolate_with(align, delta * 10.0)
	else:
		player.change_state("idle")

	var player_speed: float = player.velocity.length() / player.MAX_SPEED
	# Comparing to 0.31 for a safety margin
	if player_speed > 0.31:
		player.change_state("run")

	if Input.is_action_just_pressed("dash"):
		player.change_state("dash")

	if Input.is_action_just_pressed("jump"):
		player.change_state("jump")

	if not player.is_on_floor():
		player.change_state("fall")

	if player.is_attacking and player.can_melee():
		player.change_state("attack")

	if player.is_attacking and player.can_cast():
		player.change_state("cast")

	if player.is_attacking and player.can_shoot():
		player.change_state("shoot")

	if player.is_holding_secondary_action and player.can_block():
		player.change_state("block")


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, player.direction.x * player.MAX_SPEED, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, player.direction.z * player.MAX_SPEED, player.ACCELERATION * delta)


func _on_footstep(foot: String) -> void:
	if not player.walk_dust_particles.emitting:
		player.walk_dust_particles.emitting = true
