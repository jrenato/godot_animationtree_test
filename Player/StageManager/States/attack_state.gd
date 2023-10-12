class_name AttackState extends State

var player : Player


func _ready() -> void:
	player = get_parent()

#	# Small hack to cut the animation start and prevent sluggish animation
#	if player.current_combo_state == player.AttackComboState.REVERSE_SLICE:
#		player.animation_tree["parameters/AttackTimeSeek/seek_request"] = 0.4
#	if player.current_combo_state == player.AttackComboState.CHOP:
#		player.animation_tree["parameters/AttackTimeSeek/seek_request"] = 0.3

	player.animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func _process(delta: float) -> void:
	# Use this only if the player can control the camera
#	if player.direction:
#		var align = player.player_mesh.transform.looking_at(player.player_mesh.transform.origin - player.direction)
#		player.player_mesh.transform = player.player_mesh.transform.interpolate_with(align, delta * 10.0)

	# Hack to cut the slow end of Stab animation
#	if player.animation_tree["parameters/AttackOneShot/active"] and player.current_combo_state == player.AttackComboState.STAB:
#		if player.animation_tree["parameters/AttackStateMachine/playback"].get_current_play_position() >= 0.4:
#			player.animation_tree["parameters/AttackStateMachine/playback"].next()

	if not player.animation_tree["parameters/AttackOneShot/active"]:
		# Attack animation has ended, change to idle
		player.change_state("idle")

	if Input.is_action_just_pressed("jump"):
		# Abort attack animation and jump
		player.animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
		player.change_state("jump")

	if not player.is_on_floor():
		# Abort attack animation and fall
		player.animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
		player.change_state("fall")

	if Input.is_action_just_pressed("dash"):
		# Abort attack animation and dash
		player.animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
		player.change_state("dash")


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, player.direction.x * player.MAX_SPEED, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, player.direction.z * player.MAX_SPEED, player.ACCELERATION * delta)
