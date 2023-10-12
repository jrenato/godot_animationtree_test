extends CharacterBody3D
class_name Player

enum CharacterClass { KNIGHT, BARBARIAN, ROGUE, MAGE }

const MAX_SPEED: float = 7.0
const ACCELERATION: float = 30.0
const DASH_MAX_SPEED: float = 14.0
const DASH_ACCELERATION: float = 60.0

const JUMP_VELOCITY: float = 300.0

@export var character_class: CharacterClass = CharacterClass.KNIGHT :
	set(value):
		character_class = value
		_update_character()

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction: Vector3

var state_factory: StateFactory
var state: State

var walk_toggle: bool = false

var right_hand_equipment: EquipmentInfo
var left_hand_equipment: EquipmentInfo
var left_arm_equipment: EquipmentInfo

# Character Base
@onready var player_mesh: Node3D = %Knight
@onready var camera_controller: Node3D = %CameraController
@onready var animation_tree: AnimationTree = %AnimationTree

# Timers
@onready var dash_timer: Timer = %DashTimer

# Particles
@onready var run_dust_particles: GPUParticles3D = %RunDustParticles
@onready var walk_dust_particles: GPUParticles3D = %WalkDustParticles
@onready var dash_dust_particles: GPUParticles3D = %DashDustParticles
@onready var class_change_particles: GPUParticles3D = %ClassChangeParticles


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


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("walk_toggle"):
		walk_toggle = !walk_toggle

	if event.is_action_pressed("ui_page_up"):
		if character_class >= CharacterClass.size() - 1:
			character_class = 0 as CharacterClass
		else:
			character_class = character_class + 1 as CharacterClass

	if event.is_action_pressed("ui_page_down"):
		if character_class <= 0:
			character_class = CharacterClass.size() - 1 as CharacterClass
		else:
			character_class = character_class - 1 as CharacterClass


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

	animation_tree["parameters/MovementStateMachine/IdleRun/blend_position"].y = velocity.length() / MAX_SPEED


func _physics_process(delta: float) -> void:
	move_and_slide()

	# TODO: Study if this kind of physics simulation can be improved
	for collision_index in get_slide_collision_count():
		var collision: KinematicCollision3D = get_slide_collision(collision_index)
		if collision.get_collider() is RigidBody3D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * 0.5)
			#collision.get_collider().apply_impulse(-collision.get_normal() * 0.01, collision.get_position())


func _update_character() -> void:
	class_change_particles.restart()

	player_mesh.visible = false
	var old_transform: Transform3D = player_mesh.transform

	match character_class:
		CharacterClass.KNIGHT:
			player_mesh = %Knight
		CharacterClass.BARBARIAN:
			player_mesh = %Barbarian
		CharacterClass.ROGUE:
			player_mesh = %Rogue
		CharacterClass.MAGE:
			player_mesh = %Mage

	player_mesh.visible = true
	player_mesh.transform = old_transform

	_update_animation_tree()
	_update_equipment_references()


func _update_animation_tree() -> void:
	# Update and restart AnimationTree
	var character_string: String = CharacterClass.find_key(character_class).to_pascal_case()
	animation_tree.set_animation_player("../%s/AnimationPlayer" % character_string)
	animation_tree.active = false
	animation_tree.active = true


func _update_equipment_references() -> void:
	right_hand_equipment = null
	left_hand_equipment = null
	left_arm_equipment = null

	var right_hand: BoneAttachment3D = player_mesh.get_node("Rig/Skeleton3D/RightHand")
	var left_hand: BoneAttachment3D = player_mesh.get_node("Rig/Skeleton3D/LeftHand")
	var left_arm: BoneAttachment3D = player_mesh.get_node("Rig/Skeleton3D/LeftArm")

	_update_equipment_for_bone(right_hand, EquipmentInfo.SlotType.RIGHT_HAND)
	_update_equipment_for_bone(left_hand, EquipmentInfo.SlotType.LEFT_HAND)
	_update_equipment_for_bone(left_arm, EquipmentInfo.SlotType.LEFT_ARM)

	print("Right hand equipment: %s" % right_hand_equipment)
	print("Left hand equipment: %s" % left_hand_equipment)
	print("Left arm equipment: %s" % left_arm_equipment)


func _update_equipment_for_bone(bone_attachment: BoneAttachment3D, slot_type: EquipmentInfo.SlotType) -> void:
	if bone_attachment == null:
		return

	if bone_attachment.get_child_count() == 1:
		print(bone_attachment.get_child(0).equipment_info)
		var equipment_info: EquipmentInfo = bone_attachment.get_child(0).equipment_info as EquipmentInfo
		if equipment_info.slot_type == slot_type:
			match slot_type:
				EquipmentInfo.SlotType.RIGHT_HAND:
					right_hand_equipment = equipment_info
				EquipmentInfo.SlotType.LEFT_HAND:
					left_hand_equipment = equipment_info
				EquipmentInfo.SlotType.LEFT_ARM:
					left_arm_equipment = equipment_info


func _on_footstep(foot: String) -> void:
	if state.has_method("_on_footstep"):
		state._on_footstep(foot)
