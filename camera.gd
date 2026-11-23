extends Camera3D

@export var sensitivity: float = 0.0005

var pitch: float = 0.0
var yaw: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		yaw = clamp(yaw, deg_to_rad(-5.0), deg_to_rad(5.0))
		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, deg_to_rad(-5.0), deg_to_rad(5.0))
		rotation = Vector3(pitch, yaw, 0.0)		
