class_name RangedWeapon extends Node3D

var ammo: int = 0
var reload_required: bool = false

@export var equipment_info: EquipmentInfo
@export var arrow_scene: PackedScene

@export var base_damage: int = 0
@export var max_ammo: int = 8
@export var shoot_interval: float = 0.4

@export var interval_timer: Timer


func _ready() -> void:
	ammo = max_ammo
	if interval_timer:
		# If there's not interval_timer set, consider that
		# there's no interval between shots
		interval_timer.wait_time = shoot_interval


func shoot() -> void:
	if interval_timer and not interval_timer.is_stopped():
		return

	if not reload_required and ammo > 0:
		Signals.spawn_projectile.emit(arrow_scene, base_damage, global_transform)
		ammo -= 1

	if ammo <= 0:
		reload_required = true
	elif interval_timer:
		interval_timer.start()


func reload() -> void:
	ammo = max_ammo
	reload_required = false
