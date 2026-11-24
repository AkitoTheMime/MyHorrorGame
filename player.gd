extends CharacterBody3D

@onready var flashlight: SpotLight3D = $Camera3D/SpotLight3D

var SPEED = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flashlight.top_level = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		velocity.z = -SPEED
		print("Moving forward")
		print("X: " + str(position.x) + " Y: " + str(position.y) + " Z: " + str(position.z))
	else:
		velocity.z = 0

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight"):
		flashlight.visible = !flashlight.visible
