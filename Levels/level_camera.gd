class_name LevelCamera extends Node3D

@export var player: Player

@onready var camera: Camera3D = %Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.camera_controller = camera


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		return

	position = player.position
