class_name EquipmentInfo extends Resource

enum SlotType {RIGHT_HAND, LEFT_HAND, LEFT_ARM}

@export_group("Equipment")
@export var name: String
@export_enum("Slice", "Chop", "Stab", "Ranged", "Spellcast", "Block", "Throw", "Spellbook") var equipment_type: String
@export var equipment_slot: SlotType
@export var equipment_scene: PackedScene

@export_group("HUD")
@export var equipment_mesh: Mesh
@export var mesh_position: Vector3 = Vector3(0.0, 0.0, 0.0)
@export var mesh_rotation: Vector3 = Vector3(0.0, 0.0, 0.0)
@export var mesh_scale: Vector3 = Vector3(1.0, 1.0, 1.0)

# Equipment Types
# Left click
# * Slice: Sword - attacks
# * Chop: Axe - attacks
# * Stab: Dagger - attacks
# * Ranged: Crossbow - shoots
# Right Click
# * Spellcast: Wand - casts magic
# * Block: Shield - blocks
# * Throw: Bomb - throws
# * Spellbook: selects spell
