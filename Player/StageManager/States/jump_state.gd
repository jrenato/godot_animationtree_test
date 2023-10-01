class_name JumpState extends State

var player : Player


func _ready() -> void:
	player = get_parent()


func _process(delta: float) -> void:
	if player.is_on_floor():
		player.change_state("idle")

	if Input.is_action_just_pressed("attack"):
		player.change_state("attack")


func _physics_process(delta: float) -> void:
	player.velocity.y += move_toward(player.velocity.y, player.JUMP_VELOCITY, player.JUMP_VELOCITY/50.0)
