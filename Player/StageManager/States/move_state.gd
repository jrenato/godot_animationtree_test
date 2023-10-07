class_name MoveState extends State

var player : Player


func _ready() -> void:
	player = get_parent()


func exit() -> void:
	player.run_dust_particles.emitting = false


func _process(delta: float) -> void:
	var player_speed: float = player.velocity.length() / player.MAX_SPEED

	# Comparing to 0.31 for a safety margin
	if player.run_dust_particles.emitting and player_speed <= 0.31:
		# Player is walking, stop emitting dust
		player.run_dust_particles.emitting = false
	elif not player.run_dust_particles.emitting and player_speed > 0.31:
		# Player is running, emit dust particles
		player.run_dust_particles.emitting = true

	if player.direction:
		var align = player.player_mesh.transform.looking_at(player.player_mesh.transform.origin - player.direction)
		player.player_mesh.transform = player.player_mesh.transform.interpolate_with(align, delta * 10.0)
	else:
		player.change_state("idle")

	if Input.is_action_just_pressed("jump"):
		player.change_state("jump")

	if not player.is_on_floor():
		player.change_state("fall")

	if Input.is_action_just_pressed("dash"):
		player.change_state("dash")

	if Input.is_action_just_pressed("attack"):
		player.change_state("attack")


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, player.direction.x * player.MAX_SPEED, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, player.direction.z * player.MAX_SPEED, player.ACCELERATION * delta)
