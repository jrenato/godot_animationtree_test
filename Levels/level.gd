extends Node3D

var viewport_initial_size = Vector2()

@onready var sub_viewport: SubViewport = $WeaponHUD/SubViewport
@onready var panel: Panel = $WeaponHUD/Panel


func _ready() -> void:
	get_viewport().size_changed.connect(self._root_viewport_size_changed)
	viewport_initial_size = sub_viewport.size


# Called when the root's viewport size changes (i.e. when the window is resized).
# This is done to handle multiple resolutions without losing quality.
func _root_viewport_size_changed():
	# The viewport is resized depending on the window height.
	# To compensate for the larger resolution, the viewport sprite is scaled down.
	sub_viewport.size = Vector2.ONE * get_viewport().size.y
	#viewport_sprite.scale = Vector2.ONE * viewport_initial_size.y / get_viewport().size.y
