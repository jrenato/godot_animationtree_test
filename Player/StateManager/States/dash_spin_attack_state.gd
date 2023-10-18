class_name DashSpinAttackState extends State

var player : Player


func _ready() -> void:
	player = get_parent()
	player.animation_tree["parameters/SpinAttackTimeSeek/seek_request"] = 0.65
	player.animation_tree["parameters/SpinAttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func _process(delta: float) -> void:
	if not player.animation_tree["parameters/SpinAttackOneShot/active"]:
		player.change_state("idle")

	if not player.is_on_floor():
		player.change_state("fall")

	# Hack to cut the animation short
	if player.animation_tree["parameters/SpinAttackOneShot/active"]:
		if player.animation_tree["parameters/SpinAttackStateMachine/playback"].get_current_play_position() >= 1.4:
			player.animation_tree["parameters/SpinAttackStateMachine/playback"].next()
			player.change_state("idle")


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, 0, player.ACCELERATION * delta)
