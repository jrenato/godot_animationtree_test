class_name JumpState extends State

var player : Player


func _ready() -> void:
	player = get_parent()


func _process(delta: float) -> void:
	if player.direction:
		var align = player.player_mesh.transform.looking_at(player.player_mesh.transform.origin - player.direction)
		player.player_mesh.transform = player.player_mesh.transform.interpolate_with(align, delta * 10.0)

	if player.is_on_floor():
		player.change_state("idle")

	if player.is_attacking and player.can_melee():
		player.change_state("jump_attack")


func _physics_process(delta: float) -> void:
	player.velocity.y += move_toward(player.velocity.y, player.JUMP_VELOCITY, player.JUMP_VELOCITY/50.0)

	if player.velocity.y == player.JUMP_VELOCITY:
		player.change_state("fall")

	player.velocity.x = move_toward(player.velocity.x, player.direction.x * player.MAX_SPEED, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, player.direction.z * player.MAX_SPEED, player.ACCELERATION * delta)
