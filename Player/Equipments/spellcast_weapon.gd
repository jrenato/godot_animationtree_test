class_name SpellcastWeapon extends Node3D

@export var equipment_info: EquipmentInfo
@export var magic_scene: PackedScene
@export var spawn_point: Node3D

@export var cast_interval: float = 1.0
@export var interval_timer: Timer

@export var base_damage: int = 1

var is_recharging: bool :
	get:
		if not interval_timer:
			return false
		return not interval_timer.is_stopped()


func _ready() -> void:
	interval_timer.timeout.connect(_on_cast_interval_timer_timeout)


func cast() -> void:
	if interval_timer:
		if not interval_timer.is_stopped():
			return

		interval_timer.start()
	
#	var spawn_location: Transform3D
#	if spawn_point:
#		spawn_location = spawn_point.global_transform
#	else:
#		spawn_location = global_transform

	print("Cast!")
	#Signals.spawn_projectile.emit(magic_scene, base_damage, spawn_location)


func _on_cast_interval_timer_timeout() -> void:
	pass
