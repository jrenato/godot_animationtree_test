extends CanvasLayer

var viewport_initial_size = Vector2()

var weapons: Array[EquipmentInfo] = [
	preload("res://Player/Equipments/Resources/sword.tres"),
	preload("res://Player/Equipments/Resources/axe.tres"),
	preload("res://Player/Equipments/Resources/crossbow.tres"),
	preload("res://Player/Equipments/Resources/wand.tres")
]

@onready var sub_viewport: SubViewport = $SubViewport
@onready var panel: Panel = $Panel
@onready var equipment_hud_scene: Node3D = $SubViewport/EquipmentHUDScene


func _ready() -> void:
	get_viewport().size_changed.connect(self._root_viewport_size_changed)
	viewport_initial_size = sub_viewport.size

	equipment_hud_scene.load_weapons_in_slots(weapons)

	Signals.weapon_cycle_up.connect(_on_weapon_cycle_up)
	Signals.weapon_cycle_down.connect(_on_weapon_cycle_down)


# Called when the root's viewport size changes (i.e. when the window is resized).
# This is done to handle multiple resolutions without losing quality.
func _root_viewport_size_changed() -> void:
	# The viewport is resized depending on the window height.
	# To compensate for the larger resolution, the viewport sprite is scaled down.
	sub_viewport.size = Vector2.ONE * get_viewport().size.y
	#viewport_sprite.scale = Vector2.ONE * viewport_initial_size.y / get_viewport().size.y


func _on_weapon_cycle_up() -> void:
	equipment_hud_scene.swipe_right()


func _on_weapon_cycle_down() -> void:
	equipment_hud_scene.swipe_left()
