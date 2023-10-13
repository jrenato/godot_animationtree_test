extends Node3D

@export var sensitivity : int = 5
@export var max_zoom : float = 8.0
@export var min_zoom : float = 2.0

var desired_zoom : float = 0.0

@onready var spring_arm: SpringArm3D = %SpringArm3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	desired_zoom = spring_arm.spring_length


func _process(delta: float) -> void:
	spring_arm.spring_length = lerp(spring_arm.spring_length, desired_zoom, 0.1)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var x_rotation : float = clamp(rotation.x - event.relative.y / 1000 * sensitivity, -0.65, 0.15)
		var y_rotation : float = rotation.y - event.relative.x / 1000 * sensitivity

		if y_rotation > TAU:
			y_rotation = y_rotation - TAU
		elif y_rotation < -TAU:
			y_rotation = y_rotation + TAU

		rotation = Vector3(x_rotation, y_rotation, 0)

	if event is InputEventMouseButton:
		if event.button_index == 5:
			if desired_zoom < max_zoom:
				desired_zoom += 0.1
		if event.button_index == 4:
			if desired_zoom > min_zoom:
				desired_zoom -= 0.1
