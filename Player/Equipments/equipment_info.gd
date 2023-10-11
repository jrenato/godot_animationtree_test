class_name EquipmentInfo extends Resource

@export var name: String
@export_enum("Slice", "Chop", "Stab", "Ranged", "Spellcast", "Block", "Throw", "Spellbook") var equipment_type: String

# Slice: Sword - attack with left-click
# Chop: Axe - attack with left-click
# Stab: Dagger - attack with left-click
# Ranged: Crossbow - shoot with left-click
# Spellcast: Wand - cast magic with left-click

# Block: Shield - block with right-click
# Throw: Bomb - throw with right-click
# Spellbook: select spell with right-click

@export_enum("RightHand", "LeftHand", "LeftArm") var equipment_slot: String
@export var equipment_scene: PackedScene
@export var equipment_mesh: Mesh
