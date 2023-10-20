class_name Player extends CharacterBody3D

enum CharacterClass { KNIGHT, BARBARIAN, ROGUE, MAGE }

const MAX_SPEED: float = 7.0
const ACCELERATION: float = 30.0

const JUMP_VELOCITY: float = 300.0

@export var sensitivity : int = 5
@export var character_class: CharacterClass = CharacterClass.KNIGHT :
	set(value):
		character_class = value
		_update_character()

var camera_controller: Camera3D
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction: Vector3

var state_factory: StateFactory
var state: State

# Holding the attack button
var is_attacking: bool = false
# Action button
# * Knight: holds the shield and prepares for bash
# * Barbarian: drinks beer for self-healing
# * Rogue: aims crossbow
# * Mage: opens spellbook and start spell selection
var is_holding_secondary_action: bool = false
# Check if the mouse button is being used
var using_keyboard_mouse: bool = false
var walk_toggle: bool = false

var right_hand_equipment: Node3D
var left_hand_equipment: Node3D
var left_arm_equipment: Node3D

var _melee_types: Array[EquipmentInfo.EquipmentType] = [
	EquipmentInfo.EquipmentType.SLICE,
	EquipmentInfo.EquipmentType.CHOP,
	EquipmentInfo.EquipmentType.STAB
]

# Character Base
@onready var player_mesh: Node3D = %Knight
@onready var animation_tree: AnimationTree = %AnimationTree

# Timers
@onready var dash_timer: Timer = %DashTimer
@onready var bash_recharge_timer: Timer = %BashRechargeTimer

# Particles
@onready var run_dust_particles: GPUParticles3D = %RunDustParticles
@onready var walk_dust_particles: GPUParticles3D = %WalkDustParticles
@onready var dash_dust_particles: GPUParticles3D = %DashDustParticles
@onready var class_change_particles: GPUParticles3D = %ClassChangeParticles

@onready var look_pivot: Node3D = %LookPivot
@onready var look_point: Node3D = %LookPoint



func _ready() -> void:
	_update_equipment_references()

	state_factory = StateFactory.new()
	change_state("idle")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not using_keyboard_mouse:
		using_keyboard_mouse = true

	if event is InputEventMouseMotion and not using_keyboard_mouse:
		using_keyboard_mouse = true

	if event is InputEventKey and not using_keyboard_mouse:
		using_keyboard_mouse = true

	if event is InputEventJoypadButton and using_keyboard_mouse:
		using_keyboard_mouse = false

	if event is InputEventJoypadMotion and using_keyboard_mouse:
		using_keyboard_mouse = false

	if event.is_action_pressed("walk_toggle"):
		walk_toggle = !walk_toggle

	if event.is_action_pressed("attack"):
		is_attacking = true

	if event.is_action_released("attack"):
		is_attacking = false

	if event.is_action_pressed("secondary_action"):
		is_holding_secondary_action = true
		_update_character_secondary_action(true)
		_update_equipment_references()

	if event.is_action_released("secondary_action"):
		is_holding_secondary_action = false
		_update_character_secondary_action(false)
		_update_equipment_references()

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

	# TODO: Limit input while in AimState and SpellSelect as well
	if walk_toggle or state is BlockState:
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


func change_state(new_state_name: String) -> void:
	if state != null:
		state.exit()
		state.queue_free()

	state = state_factory.get_state(new_state_name).new()
	state.name = new_state_name
	#print(new_state_name)
	add_child(state)


func is_single_wielding() -> bool:
	if right_hand_equipment == null:
		# No equipment in right hand? Can't be single wielding
		return false

	if left_hand_equipment == null:
		# No equipment in left hand? Definitely single wielding
		return true

	# Holding two equipments?
	# Only single wielding if they belong to different types
	return right_hand_equipment.equipment_info.equipment_type != left_hand_equipment.equipment_info.equipment_type


func is_dual_wielding() -> bool:
	if right_hand_equipment == null:
		return false
	
	if left_hand_equipment == null:
		return false

	return right_hand_equipment.equipment_info.equipment_type == left_hand_equipment.equipment_info.equipment_type


func can_block() -> bool:
	if not left_arm_equipment:
		return false

	return left_arm_equipment.equipment_info.equipment_type == EquipmentInfo.EquipmentType.BLOCK


func can_aim() -> bool:
	if not right_hand_equipment:
		return false

	return right_hand_equipment.equipment_info.equipment_type == EquipmentInfo.EquipmentType.RANGED


func can_bash_attack() -> bool:
	if not can_block:
		return false

	return bash_recharge_timer.is_stopped()


func can_melee() -> bool:
	if not right_hand_equipment:
		return false

	if right_hand_equipment.equipment_info.equipment_type not in _melee_types:
		return false

	return true


func can_shoot() -> bool:
	if not right_hand_equipment:
		return false

	if right_hand_equipment.equipment_info.equipment_type != EquipmentInfo.EquipmentType.RANGED:
		return false

	return right_hand_equipment.has_method("shoot")


func shoot() -> void:
	if can_shoot() and not is_reloading():
		right_hand_equipment.shoot()


func is_reloading() -> bool:
	if not can_shoot():
		return false

	return right_hand_equipment.reload_required


func reload() -> void:
	if not can_shoot():
		return

	right_hand_equipment.reload()


func update_locked_direction() -> void:
	if using_keyboard_mouse:
		_update_mouse_direction_lock()
	else:
		_update_gamepad_direction_lock()

	var align = player_mesh.transform.looking_at(look_point.global_position - player_mesh.global_position, Vector3.UP, true)
	player_mesh.transform = player_mesh.transform.interpolate_with(align, 0.2)
	player_mesh.rotation.x = 0.0
	player_mesh.rotation.z = 0.0


func _update_gamepad_direction_lock() -> void:
		var look_input: Vector2 = Input.get_vector("look_left", "look_right", "look_up", "look_down", 0.8)
		if look_input != Vector2.ZERO:
			var target_look: Vector3 = Vector3(global_position.x + look_input.x, 0.0, global_position.z + look_input.y)
			look_pivot.look_at(target_look, Vector3.UP, true)


func _update_mouse_direction_lock() -> void:
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	var ray_from: Vector3 = camera_controller.project_ray_origin(mouse_position)
	var ray_to: Vector3 = ray_from + camera_controller.project_ray_normal(mouse_position) * camera_controller.global_position.distance_to(global_position)
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_from, ray_to)

	var intersection = get_world_3d().direct_space_state.intersect_ray(query)
	if intersection:
		look_pivot.look_at(intersection["position"], Vector3.UP, true)
	else:
		var target_look: Vector3 = ray_to
		target_look.y = position.y
		look_pivot.look_at(target_look, Vector3.UP, true)


func _update_character_secondary_action(enabled: bool) -> void:
	match character_class:
		CharacterClass.KNIGHT:
			pass
		CharacterClass.BARBARIAN:
			get_node("Barbarian/Rig/Skeleton3D/LeftHand/Axe").visible = !enabled
			get_node("Barbarian/Rig/Skeleton3D/LeftArm/ShieldRoundBarbarian").visible = enabled
		CharacterClass.ROGUE:
			pass
#			get_node("Rogue/Rig/Skeleton3D/RightHand/Dagger").visible = !enabled
#			get_node("Rogue/Rig/Skeleton3D/RightHand/Crossbow").visible = enabled
		CharacterClass.MAGE:
			pass


func _update_character() -> void:
	change_state("idle")

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

	_update_character_secondary_action(is_holding_secondary_action)
	_update_equipment_references()

	_update_animation_tree()


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

	var right_hand: BoneAttachment3D = player_mesh.get_node_or_null("Rig/Skeleton3D/RightHand")
	var left_hand: BoneAttachment3D = player_mesh.get_node_or_null("Rig/Skeleton3D/LeftHand")
	var left_arm: BoneAttachment3D = player_mesh.get_node_or_null("Rig/Skeleton3D/LeftArm")

	_update_equipment_for_bone(right_hand, EquipmentInfo.SlotType.RIGHT_HAND)
	_update_equipment_for_bone(left_hand, EquipmentInfo.SlotType.LEFT_HAND)
	_update_equipment_for_bone(left_arm, EquipmentInfo.SlotType.LEFT_ARM)

#	if right_hand_equipment != null:
#		print("Right hand: %s" % right_hand_equipment.equipment_info.name)
#	if left_hand_equipment != null:
#		print("Left hand: %s" % left_hand_equipment.equipment_info.name)
#	if left_arm_equipment != null:
#		print("Left arm: %s" % left_arm_equipment.equipment_info.name)


func _update_equipment_for_bone(bone_attachment: BoneAttachment3D, slot_type: EquipmentInfo.SlotType) -> void:
	if bone_attachment == null:
		return

	for equipment in bone_attachment.get_children():
		if equipment.visible:
			var equipment_info: EquipmentInfo = equipment.equipment_info as EquipmentInfo
			if slot_type in equipment_info.slots:
				match slot_type:
					EquipmentInfo.SlotType.RIGHT_HAND:
						right_hand_equipment = equipment
					EquipmentInfo.SlotType.LEFT_HAND:
						left_hand_equipment = equipment
					EquipmentInfo.SlotType.LEFT_ARM:
						left_arm_equipment = equipment
			return


func _on_footstep(foot: String) -> void:
	if state.has_method("_on_footstep"):
		state._on_footstep(foot)
