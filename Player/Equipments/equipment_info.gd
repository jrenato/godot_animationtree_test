class_name EquipmentInfo extends Resource

enum SlotType { RIGHT_HAND, LEFT_HAND, LEFT_ARM }
enum EquipmentType {
	SLICE, CHOP, STAB, RANGED, SPELLCAST, BLOCK, THROW, SPELLBOOK
}

@export_group("Equipment")
@export var name: String
@export var equipment_type: EquipmentType
@export var slots: Array[SlotType] = [SlotType.RIGHT_HAND]

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
