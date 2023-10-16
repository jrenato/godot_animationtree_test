class_name LevelCamera extends Node3D

@export var player: Player
@export var speed: float = 5.0

@onready var camera: Camera3D = %Camera3D


func _ready() -> void:
	player.camera_controller = camera


func _process(delta: float) -> void:
	if not player:
		return

	position = position.move_toward(player.position, speed * delta)
	#global_position.x = lerpf(global_position.x, player.global_position.x, speed * delta)
	#global_position.z = lerpf(global_position.z, player.global_position.z, speed * delta)
	#print(position)
