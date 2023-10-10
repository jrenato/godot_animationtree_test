extends Node3D

@export var base_slot_node: PackedScene

var is_swiping: bool = false

var _weapons: Array

@onready var weapons_nodes: Node3D = $WeaponNodes/Weapons
@onready var slots_nodes: Node3D = %Slots


func load_weapons_in_slots(weapons: Array) -> void:
	_weapons = weapons

	for i in range(weapons.size()):
		# Duplicate the base slot node and add it to slots_nodes
		var new_slot: Node3D = base_slot_node.instantiate()
		slots_nodes.add_child(new_slot)
		new_slot.name = "Slot%s" % i

		# Set the new slot position
		if i < weapons.size() - 1:
			new_slot.position.x = i * 2
		else:
			new_slot.position.x = -2

		# Add the weapon to the new slot
		var weapon_node: Node3D = get_weapon_node_by_name(weapons[i])
		var new_weapon_now: Node3D = weapon_node.duplicate()
		if new_weapon_now != null:
			new_slot.get_node("PositionNode/WeaponSlot").add_child(new_weapon_now)


func get_weapon_node_by_name(weapon_name: String) -> Node3D:
	for weapon_node in weapons_nodes.get_children():
		if weapon_node.name == weapon_name:
			return weapon_node

	return null


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
	swipe(Vector3.RIGHT)


func swipe_left() -> void:
	swipe(Vector3.LEFT)


func _on_swipe_finished() -> void:
	for slot_node in slots_nodes.get_children():
		if slot_node.position.x >= (_weapons.size() - 1) * 2:
			slot_node.position.x = -2

		if slot_node.position.x <= -4:
			slot_node.position.x = (_weapons.size() - 2) * 2

	is_swiping = false
