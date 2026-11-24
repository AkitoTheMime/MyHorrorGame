extends CharacterBody3D

var SPEED = 1

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_W):
		velocity.z = -SPEED
	else:
		velocity.z = 0

	move_and_slide()
