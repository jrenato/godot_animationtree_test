class_name Arrow extends Projectile

@export var speed: float = 10.0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if target_hit != null:
		queue_free()


func _physics_process(delta: float) -> void:
	velocity.x = move_toward(velocity.x, transform.basis.z.x * speed, speed)
	velocity.z = move_toward(velocity.z, transform.basis.z.z * speed, speed)

	super(delta)
