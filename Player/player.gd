extends CharacterBody3D
class_name Player

enum AttackComboState { IDLE, SLICE, REVERSE_SLICE, CHOP }

const RUN_MAX_SPEED: float = 5.0
const ACCELERATION: float = 30.0
const DASH_MAX_SPEED: float = 10.0
const DASH_ACCELERATION: float = 60.0

const JUMP_VELOCITY: float = 300.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction: Vector3

var state_factory: StateFactory
var state: State

var walk_toggle: bool = false

var current_combo_state: AttackComboState = AttackComboState.IDLE
var next_combo_state: AttackComboState = AttackComboState.SLICE

@onready var camera_controller: Node3D = %CameraController
@onready var player_mesh: Node3D = %Knight
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var dash_timer: Timer = %DashTimer
@onready var next_combo_timer: Timer = %NextComboTimer
@onready var left_foot_point: Node3D = %LeftFootPoint
@onready var right_foot_point: Node3D = %RightFootPoint
@onready var run_dust_particles: GPUParticles3D = %RunDustParticles


func _ready() -> void:
	run_dust_particles.emitting = false
	next_combo_timer.timeout.connect(_on_next_combo_timer_timeout)

	state_factory = StateFactory.new()
	change_state("idle")


func change_state(new_state_name: String) -> void:
	if state != null:
		state.exit()
		state.queue_free()

	state = state_factory.get_state(new_state_name).new()
	state.name = new_state_name
	add_child(state)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("walk_toggle"):
		walk_toggle = !walk_toggle


func _process(delta: float) -> void:
	# Get the input direction
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Sets the direction to the camera's basis and normalize it.
	direction = (camera_controller.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0.0

	animation_tree["parameters/Movement/IdleRun/blend_position"].y = velocity.length() / RUN_MAX_SPEED


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_next_combo_timer_timeout() -> void:
	if current_combo_state == AttackComboState.SLICE:
		next_combo_state = AttackComboState.REVERSE_SLICE

	if current_combo_state == AttackComboState.REVERSE_SLICE:
		next_combo_state = AttackComboState.CHOP


func _on_footstep() -> void:
	#TODO: Replace run dust particles with footsteps particles
	pass
