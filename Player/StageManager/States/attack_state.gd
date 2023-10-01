class_name AttackState extends State

var player : Player


func _ready() -> void:
	player = get_parent()

	# A combo check only makes sense if the player is on the floor
	if player.is_on_floor():
		# Advances the current combo state to the next state
		if player.current_combo_state != player.next_combo_state:
			player.current_combo_state = player.next_combo_state

	# Small hack to cut the animation start and prevent sluggish animation
	if player.current_combo_state == player.AttackComboState.REVERSE_SLICE:
		player.animation_tree["parameters/TimeSeek/seek_request"] = 0.4
	if player.current_combo_state == player.AttackComboState.CHOP:
		player.animation_tree["parameters/TimeSeek/seek_request"] = 0.3

	player.animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	player.next_combo_timer.start()


func _process(delta: float) -> void:
	if player.direction:
		var align = player.player_mesh.transform.looking_at(player.player_mesh.transform.origin - player.direction)
		player.player_mesh.transform = player.player_mesh.transform.interpolate_with(align, delta * 10.0)

	if not player.animation_tree["parameters/AttackOneShot/active"]:
		# Reset combo if AttackOneShot has ended
		player.current_combo_state = player.AttackComboState.IDLE
		player.next_combo_state = player.AttackComboState.SLICE
		player.change_state("idle")

	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		# Abort attack animation and jump
		player.animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
		player.change_state("jump")

	# A combo check only makes sense if the player is on the floor
	if Input.is_action_just_pressed("attack") and player.is_on_floor() and player.animation_tree["parameters/AttackOneShot/active"]:
		# Repeat attack command if the next combo state is ready (NextComboTimer has timed out)
		if player.current_combo_state != player.next_combo_state:
			player.change_state("attack")


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, player.direction.x * player.MAX_SPEED, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, player.direction.z * player.MAX_SPEED, player.ACCELERATION * delta)
