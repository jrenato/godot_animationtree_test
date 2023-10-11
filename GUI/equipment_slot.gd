class_name EquipmentSlot extends Node3D

var equipment: EquipmentInfo :
	set(value):
		equipment = value
		equipment_mesh.mesh = equipment.equipment_mesh
		equipment_mesh.position = equipment.mesh_position
		equipment_mesh.rotation = equipment.mesh_rotation
		equipment_mesh.scale = equipment.mesh_scale

@onready var equipment_mesh: MeshInstance3D = %EquipmentMesh
