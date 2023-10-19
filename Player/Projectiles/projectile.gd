class_name Projectile extends CharacterBody3D

var base_damage: float = 0
var target_hit: Node3D


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	move_and_slide()

	for index in get_slide_collision_count():
		var collision: KinematicCollision3D = get_slide_collision(index)
		target_hit = collision.get_collider()
		# TODO: for future reference
#		if collision.get_collider() is Player:
#			var collided_player: Player = collision.get_collider()


func destroy() -> void:
	queue_free()
