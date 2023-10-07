class_name JumpAttackState extends State

var player : Player


func _ready() -> void:
	player = get_parent()
	player.animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func _process(delta: float) -> void:
	if player.direction:
		var align = player.player_mesh.transform.looking_at(player.player_mesh.transform.origin - player.direction)
		player.player_mesh.transform = player.player_mesh.transform.interpolate_with(align, delta * 10.0)

	if not player.animation_tree["parameters/AttackOneShot/active"]:
		# Revert to fall state if attack has ended
		player.change_state("fall")


func _physics_process(delta: float) -> void:
	player.velocity.y -= player.gravity * delta

	player.velocity.x = move_toward(player.velocity.x, player.direction.x * player.RUN_MAX_SPEED, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, player.direction.z * player.RUN_MAX_SPEED, player.ACCELERATION * delta)
