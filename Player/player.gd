extends CharacterBody3D
class_name Player

enum AttackComboState { IDLE, SLICE, REVERSE_SLICE, CHOP, STAB }

const MAX_SPEED: float = 7.0
const ACCELERATION: float = 30.0
const DASH_MAX_SPEED: float = 14.0
const DASH_ACCELERATION: float = 60.0

const JUMP_VELOCITY: float = 300.0

@export var run_dust_curve: Resource
@export var walk_dust_curve: Resource
#var run_curve: Resource = preload("res://Player/StageManager/Resources/dust_run_scale.tres")

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
	var raw_input: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if walk_toggle:
		# To be able to walk while using a keyboard
		raw_input.x = raw_input.x * 0.3
		raw_input.y = raw_input.y * 0.3

	direction = Vector3.ZERO

	# This is to ensure that diagonal input isn't stronger than axis aligned input
	direction.x = raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
	direction.z = raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)

	direction = camera_controller.global_transform.basis * direction
	direction.y = 0.0

	animation_tree["parameters/Movement/IdleRun/blend_position"].y = velocity.length() / MAX_SPEED


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_next_combo_timer_timeout() -> void:
	if current_combo_state == AttackComboState.SLICE:
		next_combo_state = AttackComboState.CHOP

	if current_combo_state == AttackComboState.CHOP:
		next_combo_state = AttackComboState.STAB


func _on_footstep(foot: String) -> void:
	if state.has_method("_on_footstep"):
		state._on_footstep(foot)
