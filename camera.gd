extends Camera3D

@export var sensitivity: float = 0.0005
@onready var flashlight: SpotLight3D = $SpotLight3D
@export var sway_speed: float = 12.0

var pitch: float = 0.0
var yaw: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flashlight.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	get_viewport().warp_mouse(get_viewport().get_visible_rect().size / 2)
	pitch = 0.0
	yaw = 0.0
	rotation = Vector3.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var center = get_viewport().get_visible_rect().size / 2.0

		var mouse_pos = get_viewport().get_mouse_position()
		var offset = mouse_pos - center

		yaw = -offset.x * sensitivity
		pitch = -offset.y * sensitivity

		pitch = clamp(pitch, deg_to_rad(-5.0), deg_to_rad(5.0))
		yaw = clamp(yaw, deg_to_rad(-5.0), deg_to_rad(5.0))

		rotation = Vector3(pitch, yaw, 0.0)
