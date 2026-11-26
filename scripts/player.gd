extends CharacterBody3D

var SPEED = 2
var is_rotating: bool = false
@onready var timer: Timer = $Timer
@onready var footstep: AudioStreamPlayer3D = $Footsteps
@onready var menu: Control = $IngameMenu

func _ready() -> void:
	menu.visible = false
	timer.one_shot = true
	rotate_y(deg_to_rad(0.0))

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_W) and int(rotation.y) == 0: # IF MOVEMENT IS FROZEN CHECK THIS CONDITIONAL
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("look_behind") and velocity.z == 0.0:
		rotate_180()
	else:
		rotate_y(deg_to_rad(0.0))
	
	if event.is_action_pressed("look_left"):
		rotate_90_left()
	if event.is_action_pressed("look_right"):
		rotate_90_right()
	
	if event.is_action_pressed("ingame_menu"):
		menu.visible = !menu.visible
		if menu.visible:
			get_tree().paused = true

func rotate_90_left() -> void:
	if is_rotating:
		return
		
	is_rotating = true
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "rotation:y", rotation.y + (PI/2), 0.5)
	
	await tween.finished
	is_rotating = false

func rotate_90_right() -> void:
	if is_rotating:
		return
		
	is_rotating = true
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "rotation:y", rotation.y - (PI/2), 0.5)
	
	await tween.finished
	is_rotating = false

func rotate_180() -> void:
	if is_rotating:
		return
		
	is_rotating = true
	var pct = randf_range(1, 10)
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	if pct <= 5:
		tween.tween_property(self, "rotation:y", rotation.y + PI, 0.5)
	else:
		tween.tween_property(self, "rotation:y", rotation.y - PI, 0.5)
	
	await tween.finished
	is_rotating = false
