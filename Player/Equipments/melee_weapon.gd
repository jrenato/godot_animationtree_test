class_name MeleeWeapon extends Area3D

@export var equipment_info: EquipmentInfo
@export var base_damage: int = 1

var weapon_enabled: bool = false :
	set(value):
		weapon_enabled = value
		get_node("CollisionShape3D").disabled = !weapon_enabled


func enable_weapon() -> void:
	weapon_enabled = true


func disable_weapon() -> void:
	weapon_enabled = false
