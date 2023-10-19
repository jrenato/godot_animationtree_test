class_name Crossbow extends RangedWeapon

@export var base_shoot_interval: float = 0.4

@onready var shoot_interval_timer: Timer = %ShootIntervalTimer


func _ready() -> void:
	shoot_interval_timer.wait_time = base_shoot_interval


func shoot() -> void:
	if shoot_interval_timer.is_stopped():
		super()
		shoot_interval_timer.start()
