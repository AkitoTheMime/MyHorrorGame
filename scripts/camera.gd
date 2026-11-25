extends Camera3D

@export var sensitivity: float = 0.0005
@onready var flashlight: SpotLight3D = $Flashlight
@onready var flashlight_sound: AudioStreamPlayer3D = $Flashlight/FlashlightSound

var pitch: float = 0.0
var yaw: float = 0.0

var camera_start_position: Vector3

@export_group("Head Bob")
@export var bob_frequency: float = 1.5
@export var bob_amplitude: float = 0.04
@export var bob_smoothing: float = 8.0

var bob_time: float = 0.0

@export_group("Idle Bob")
@export var idle_frequency: float = 1.0
@export var idle_amplitude: float = 0.010
@export var idle_rotation: float = 0.002
@export var idle_smoothing: float = 2.5

var idle_time: float = 0.0


func _ready() -> void:
	flashlight.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	pitch = 0.0
	yaw = 0.0
	rotation = Vector3.ZERO

	camera_start_position = position


func _process(delta: float) -> void:
	_update_camera_bob(delta)

	var screen_center = get_viewport().get_visible_rect().size / 2.0
	var mouse_pos = get_viewport().get_mouse_position()

	var mouse_offset = mouse_pos - screen_center

	var ray_origin = project_ray_origin(screen_center + mouse_offset)
	var ray_direction = project_ray_normal(screen_center + mouse_offset)

	flashlight.global_position = global_position
	flashlight.look_at(
		ray_origin + ray_direction * 100.0,
		Vector3.UP
	)

	if Input.is_key_pressed(KEY_Q):
		print("Looking Behind Left")

	if Input.is_key_pressed(KEY_E):
		print("Looking Behind Right")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity

		pitch = clamp(pitch, deg_to_rad(-5.0), deg_to_rad(5.0))
		yaw = clamp(yaw, deg_to_rad(-5.0), deg_to_rad(5.0))

		rotation.x = pitch
		rotation.y = yaw

	if event.is_action_pressed("flashlight"):
		flashlight_sound.play()
		flashlight.visible = !flashlight.visible


func _update_camera_bob(delta: float) -> void:
	var is_moving = Input.is_key_pressed(KEY_W)

	var target_position: Vector3
	var target_rotation_z: float

	if is_moving:
		# Walking head bob
		bob_time += delta * bob_frequency * TAU
		idle_time = 0.0

		var bob_offset = sin(bob_time) * bob_amplitude

		target_position = camera_start_position + Vector3(0, bob_offset, 0)
		target_rotation_z = 0.0

	else:
		# Idle breathing bob
		idle_time += delta * idle_frequency * TAU
		bob_time = 0.0

		var idle_y = sin(idle_time) * idle_amplitude
		var idle_x = cos(idle_time) * idle_amplitude * 0.5

		target_position = camera_start_position + Vector3(
			idle_x,
			idle_y,
			0
		)

		target_rotation_z = sin(idle_time) * idle_rotation

	# Smoothly interpolate between both states
	var smoothing = bob_smoothing if is_moving else idle_smoothing

	position = position.lerp(
		target_position,
		clamp(delta * smoothing, 0.0, 1.0)
	)

	rotation.z = lerp_angle(
		rotation.z,
		target_rotation_z,
		clamp(delta * idle_smoothing, 0.0, 1.0)
	)
