class_name MoveState extends State

var player : Player


func _ready() -> void:
	player = get_parent()
	player.run_dust_particles.emitting = true


func exit() -> void:
	player.run_dust_particles.emitting = false


func _process(delta: float) -> void:
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
#	if player.walk_toggle:
#		player.direction.x = min(player.direction.x, 0.2)
#		player.direction.z = min(player.direction.z, 0.2)

	player.velocity.x = move_toward(player.velocity.x, player.direction.x * player.RUN_MAX_SPEED, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, player.direction.z * player.RUN_MAX_SPEED, player.ACCELERATION * delta)
