class_name Arrow extends Ammo

var speed: float = 0.1


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	velocity.x = move_toward(velocity.x, transform.basis.z.x * speed, speed)
	velocity.z = move_toward(velocity.z, transform.basis.z.z * speed, speed)
	move_and_slide()
