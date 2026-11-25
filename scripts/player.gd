extends CharacterBody3D

var SPEED = 2

@onready var timer: Timer = $Timer
@onready var footstep: AudioStreamPlayer3D = $Footsteps

func _ready() -> void:
	timer.one_shot = true

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_W):
		velocity.z = -SPEED

		if timer.is_stopped():
			footstep.play()
			timer.start()
	else:
		velocity.z = 0
		timer.stop()

	move_and_slide()

func _on_timer_timeout() -> void:
	if Input.is_key_pressed(KEY_W):
		footstep.play()
		timer.start()
