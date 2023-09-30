class_name IdleState extends State

var player : Player


func _ready() -> void:
	player = get_parent()


func _process(delta: float) -> void:
	if player.direction:
		player.change_state("move")

	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.change_state("jump")

	if Input.is_action_just_pressed("attack") and player.is_on_floor():
		player.change_state("attack")


func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.ACCELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, 0, player.ACCELERATION * delta)
