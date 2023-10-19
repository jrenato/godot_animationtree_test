extends Node3D


func _ready() -> void:
	Signals.spawn_projectile.connect(_on_spawn_projectile)


func _on_spawn_projectile(projectile_scene: PackedScene, base_damage: float, origin_transform: Transform3D) -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.base_damage = base_damage
	projectile.global_transform = origin_transform
	add_child(projectile)
	projectile.rotation.x = 0
	projectile.rotation.z = 0
