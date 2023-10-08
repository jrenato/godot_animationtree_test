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
	player.dash_dust_particles.emitting = false


func _process(delta: float) -> void:
	if not player.is_on_floor():
		player.change_state("fall")

	#TODO: Add DashAttack state and set it up on AnimationTree
	#if Input.is_action_just_pressed("attack"):
		#player.change_state("attack")


func _physics_process(delta: float) -> void:
		player.velocity.x = move_toward(player.velocity.x, dash_direction.x * player.DASH_MAX_SPEED, player.DASH_ACCELERATION * delta)
		player.velocity.z = move_toward(player.velocity.z, dash_direction.z * player.DASH_MAX_SPEED, player.DASH_ACCELERATION * delta)


func _on_dash_timer_timeout() -> void:
	player.change_state("idle")
