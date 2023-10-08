class_name DashState extends State

var player: Player
var dash_direction: Vector3


func _ready() -> void:
	player = get_parent()
	player.dash_dust_particles.emitting = true

	dash_direction = player.player_mesh.basis.z
	player.dash_timer.timeout.connect(_on_dash_timer_timeout)
	player.dash_timer.start()


func exit() -> void:
	player.dash_timer.stop()
	player.dash_dust_particles.emitting = false

func _process(delta: float) -> void:
	if not player.is_on_floor():
		player.change_state("fall")

	if Input.is_action_just_pressed("attack"):
		# If the player hit the button at the correct time, perform a special attack
		if player.dash_timer.time_left <= 0.2:
			player.change_state("dash_spin_attack")
		else:
			# Otherwise, just perform a common attack
			player.change_state("attack")


func _physics_process(delta: float) -> void:
		player.velocity.x = move_toward(player.velocity.x, dash_direction.x * player.DASH_MAX_SPEED, player.DASH_ACCELERATION * delta)
		player.velocity.z = move_toward(player.velocity.z, dash_direction.z * player.DASH_MAX_SPEED, player.DASH_ACCELERATION * delta)


func _on_dash_timer_timeout() -> void:
	player.change_state("idle")
