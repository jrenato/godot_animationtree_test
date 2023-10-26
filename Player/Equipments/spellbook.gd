class_name Spellbook extends Node3D

@export var equipment_info: EquipmentInfo
@export var spell_weapon: SpellcastWeapon

var active: bool = false :
	set(value):
		active = value
		spellbook_open.visible = active
		spellbook_closed.visible = !active

@onready var spellbook_open: MeshInstance3D = %spellbook_open
@onready var spellbook_closed: MeshInstance3D = %spellbook_closed


func choose() -> void:
	pass
