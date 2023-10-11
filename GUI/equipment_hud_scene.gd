extends Node3D

@export var base_slot_node: PackedScene

var is_swiping: bool = false

var _weapons: Array[EquipmentInfo]

@onready var weapons_nodes: Node3D = $WeaponNodes/Weapons
@onready var slots_nodes: Node3D = %Slots


func load_weapons_in_slots(weapons: Array[EquipmentInfo]) -> void:
	_weapons = weapons

	for i in range(_weapons.size()):
		# Duplicate the base slot node and add it to slots_nodes
		var equipment_slot: EquipmentSlot = base_slot_node.instantiate()
		slots_nodes.add_child(equipment_slot)
		equipment_slot.name = "Slot%s" % i

		# Set the new slot position
		if i < _weapons.size() - 1:
			equipment_slot.position.x = i * 2
		else:
			equipment_slot.position.x = -2

		# Set the equipment data
		equipment_slot.equipment = _weapons[i]


func swipe(swipe_direction: Vector3) -> void:
	if is_swiping:
		return

	is_swiping = true

	var tween = create_tween()
	for slot_node in slots_nodes.get_children():
		tween.parallel().tween_property(slot_node, "position", slot_node.position + (swipe_direction * 2), 0.3)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
	tween.tween_callback(_on_swipe_finished)


func swipe_right() -> void:
	swipe(Vector3.LEFT)


func swipe_left() -> void:
	swipe(Vector3.RIGHT)


func _on_swipe_finished() -> void:
	for slot_node in slots_nodes.get_children():
		if slot_node.position.x >= (_weapons.size() - 1) * 2:
			slot_node.position.x = -2

		if slot_node.position.x <= -4:
			slot_node.position.x = (_weapons.size() - 2) * 2

		if slot_node.position.x == 0:
			Signals.equipment_equipped.emit(slot_node.equipment)

	is_swiping = false
