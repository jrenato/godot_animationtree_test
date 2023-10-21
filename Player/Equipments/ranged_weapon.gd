class_name RangedWeapon extends Node3D

var ammo: int = 0
var reload_required: bool = false

@export var equipment_info: EquipmentInfo
@export var arrow_scene: PackedScene
@export var spawn_point: Node3D
@export var ammo_mesh: MeshInstance3D

@export var base_damage: int = 0
@export var max_ammo: int = 8
@export var shoot_interval: float = 0.4

@export var interval_timer: Timer


func _ready() -> void:
	ammo = max_ammo
	if interval_timer:
		# If there's not interval_timer set, consider that
		# there's no interval between shots
		interval_timer.timeout.connect(_on_shoot_interval_timer_timeout)
		interval_timer.wait_time = shoot_interval


func shoot() -> void:
	if interval_timer and not interval_timer.is_stopped():
		return

	if not reload_required and ammo > 0:
		if ammo_mesh:
			ammo_mesh.visible = false

		var spawn_location: Transform3D
		if spawn_point:
			spawn_location = spawn_point.global_transform
		else:
			spawn_location = global_transform

		Signals.spawn_projectile.emit(arrow_scene, base_damage, spawn_location)

		ammo -= 1

	if ammo <= 0:
		reload_required = true
	elif interval_timer:
		interval_timer.start()


func reload() -> void:
	ammo = max_ammo
	reload_required = false
	if ammo_mesh:
		ammo_mesh.visible = true


func _on_shoot_interval_timer_timeout() -> void:
	if not reload_required and ammo_mesh:
		ammo_mesh.visible = true
