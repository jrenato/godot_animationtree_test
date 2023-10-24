class_name AttackState extends State

var player : Player


func _ready() -> void:
	player = get_parent()
	start_animation()


func exit() -> void:
	stop_animation()


func _process(delta: float) -> void:
	if player.direction:
		var align = player.player_mesh.transform.looking_at(player.player_mesh.transform.origin - player.direction)
		player.player_mesh.transform = player.player_mesh.transform.interpolate_with(align, delta * 10.0)

	if not is_running_animation():
		# Attack animation has ended, change to idle
		player.change_state("idle")

	if Input.is_action_just_pressed("jump"):
		# Abort attack animation and jump
		stop_animation()
		player.change_state("jump")

	if not player.is_on_floor():
		# Abort attack animation and fall
		stop_animation()
		player.change_state("fall")

	if Input.is_action_just_pressed("dash"):
		# Abort attack animation and dash
		stop_animation()
		player.change_state("dash")


func start_animation() -> void:
	if not player.is_dual_wielding():
		player.animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	else:
		player.animation_tree["parameters/DualAttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func is_running_animation() -> bool:
	return player.animation_tree["parameters/AttackOneShot/active"] \
		or player.animation_tree["parameters/DualAttackOneShot/active"]


func stop_animation() -> void:
	if not player.is_dual_wielding():
		player.animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	else:
		player.animation_tree["parameters/DualAttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, player.direction.x * player.MAX_SPEED, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, player.direction.z * player.MAX_SPEED, player.ACCELERATION * delta)
