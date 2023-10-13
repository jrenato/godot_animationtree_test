class_name LevelCamera extends Node3D

@export var player: Player

@onready var camera: Camera3D = %Camera3D


func _ready() -> void:
	player.camera_controller = camera


func _physics_process(delta: float) -> void:
	if not player:
		return

	position = position.move_toward(player.position, 10.0 * delta)
