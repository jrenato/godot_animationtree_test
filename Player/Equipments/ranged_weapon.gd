class_name RangedWeapon extends Node3D

@export var equipment_info: EquipmentInfo
@export var base_damage: int = 0
@export var arrow_scene: PackedScene


func shoot() -> void:
	Signals.spawn_projectile.emit(arrow_scene, base_damage, global_transform)
