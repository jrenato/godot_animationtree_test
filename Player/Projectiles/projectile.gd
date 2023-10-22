class_name Projectile extends CharacterBody3D

@export var speed: float = 10.0

var base_damage: float = 1
var target_hit: Node3D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if target_hit != null:
		queue_free()


func _physics_process(delta: float) -> void:
	velocity.x = move_toward(velocity.x, transform.basis.z.x * speed, speed)
	velocity.z = move_toward(velocity.z, transform.basis.z.z * speed, speed)

	move_and_slide()

	for index in get_slide_collision_count():
		var collision: KinematicCollision3D = get_slide_collision(index)
		target_hit = collision.get_collider()
		# TODO: for future reference
#		if collision.get_collider() is Player:
#			var collided_player: Player = collision.get_collider()


func destroy() -> void:
	queue_free()
