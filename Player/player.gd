extends CharacterBody3D
class_name Player

const MAX_SPEED: float = 5.0
const ACCELERATION: float = 30.0
const JUMP_VELOCITY: float = 300.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction: Vector3
var state_factory: StateFactory
var state: State
var reverse_attack_enabled: bool = false

@onready var camera_controller: Node3D = %CameraController
@onready var player_mesh: Node3D = %Knight
@onready var animation_tree: AnimationTree = %AnimationTree


func _ready() -> void:
	state_factory = StateFactory.new()
	change_state("idle")


func change_state(new_state_name: String) -> void:
	if state != null:
		state.exit()
		state.queue_free()

	state = state_factory.get_state(new_state_name).new()
	state.name = new_state_name
	add_child(state)


func _process(delta: float) -> void:
	# Get the input direction
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Sets the direction to the camera's basis and normalize it.
	direction = (camera_controller.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0.0

	animation_tree["parameters/Movement/IdleRun/blend_position"].y = velocity.length() / MAX_SPEED


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()


func enable_reverse_attack() -> void:
	print("Enabling reverse attack")
	reverse_attack_enabled = true
