class_name EquipmentInfo extends Resource

enum SlotType {RIGHT_HAND, LEFT_HAND, LEFT_ARM}

@export_group("Equipment")
@export var name: String
@export_enum("Slice", "Chop", "Stab", "Ranged", "Spellcast", "Block", "Throw", "Spellbook") var equipment_type: String
@export var equipment_slot: SlotType

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
