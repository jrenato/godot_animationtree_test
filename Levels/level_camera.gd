class_name LevelCamera extends Node3D

@export var player: Player
@export var speed: float = 10.0

@onready var camera: Camera3D = %Camera3D


func _ready() -> void:
	player.camera_controller = camera


func _process(delta: float) -> void:
	if not player:
		return

	#position = position.move_toward(player.position, speed * delta)
	position = lerp(position, player.position, speed * delta)
	#transform.origin = lerp(transform.origin, player.transform.origin, speed * delta)
