class_name DashState extends State

const DASH_MAX_SPEED: float = 14.0
const DASH_ACCELERATION: float = 60.0

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

	if player.is_attacking and player.can_melee():
		# If the player hit the button at the correct time, perform a special attack
		if player.dash_timer.time_left <= 0.2:
			player.change_state("dash_spin_attack")
		else:
			# Otherwise, just perform a common attack
			player.change_state("attack")


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, dash_direction.x * DASH_MAX_SPEED, DASH_ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, dash_direction.z * DASH_MAX_SPEED, DASH_ACCELERATION * delta)


func _on_dash_timer_timeout() -> void:
	player.change_state("idle")
