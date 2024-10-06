extends Camera3D

var mouse_sens = 0.3
var yaw = 0
var pitch = 0
var pitch_limit = 85
var camera_unlocked = false

func _ready() -> void:
	# Initialize yaw and pitch from the current camera orientation
	var forward = -transform.basis.z.normalized()
	yaw = atan2(forward.x, forward.z)
	pitch = asin(forward.y)

func _process(delta: float) -> void:
	# Update the camera's orientation based on yaw and pitch
	var rotation_y = Basis(Vector3.UP, yaw)
	var rotation_x = Basis(Vector3.RIGHT, pitch)
	transform.basis = rotation_y * rotation_x

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		# Toggle camera unlocked state with right-click
		camera_unlocked = event.pressed
		
	
	if event is InputEventMouseMotion and camera_unlocked:
		# Rotate the camera based on mouse movement
		yaw -= deg_to_rad(event.relative.x * mouse_sens)
		pitch -= deg_to_rad(event.relative.y * mouse_sens)
		# Clamp the pitch to prevent the camera from flipping upside down
		#pitch = clamp(pitch, deg_to_rad(-pitch_limit), deg_to_rad(pitch_limit))

	# Remove zoom functionality as it's no longer needed for this setup
