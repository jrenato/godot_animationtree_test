class_name SpellChooseState extends State

var player : Player


func _ready() -> void:
	player = get_parent()
	player.animation_tree["parameters/MoveBlockAimOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func _process(delta: float) -> void:
	player.update_locked_direction()

	if not player.is_on_floor():
		player.change_state("fall")

	if player.is_attacking and player.can_choose():
		# TODO: Call choose spell
		pass
#		if not player.animation_tree["parameters/AttackOneShot/active"]:
#			player.animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, 0, player.ACCELERATION * delta)


func _on_footstep(foot: String) -> void:
	if not player.walk_dust_particles.emitting:
		player.walk_dust_particles.emitting = true
