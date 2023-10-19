extends Node

signal weapon_cycle_up
signal weapon_cycle_down

signal equipment_equipped(equipment_info: EquipmentInfo)

signal spawn_projectile(projectile: PackedScene, base_damage: float, transform: Transform3D)
