class_name RangedWeapon extends Node3D

@export var equipment_info: EquipmentInfo
@export var base_damage: int = 1
@export var arrow_scene: PackedScene


func shoot() -> void:
	var projectile: Arrow = arrow_scene.instantiate()
