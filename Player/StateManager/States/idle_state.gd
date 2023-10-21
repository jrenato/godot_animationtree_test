class_name IdleState extends State

var player : Player


func _ready() -> void:
	player = get_parent()


func _process(delta: float) -> void:
	if player.direction:
		player.change_state("walk")

	if Input.is_action_just_pressed("dash"):
		player.change_state("dash")

	if Input.is_action_just_pressed("jump"):
		player.change_state("jump")

	if not player.is_on_floor():
		player.change_state("fall")

	if player.is_attacking and player.can_melee():
		player.change_state("attack")

	if player.is_attacking and player.can_shoot():
		player.change_state("shoot")

	if player.is_attacking and player.can_cast():
		player.change_state("cast")

	if player.is_holding_secondary_action and player.can_block():
		player.change_state("block")


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, 0, player.ACCELERATION * delta)
