extends Camera3D

var mouse_sens = 0.3
var camera_anglev = 0
var camera_unlocked = false
var zoom_speed = 1.0
var min_fov = 10.0
var max_fov = 90.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _input(event):  		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			camera_unlocked = true
		else:
			camera_unlocked = false
	
	if event is InputEventMouseMotion and camera_unlocked:
		rotate_z(deg_to_rad(-event.relative.x * mouse_sens))
		var changev = -event.relative.y * mouse_sens
		#if camera_anglev + changev > -50 and camera_anglev + changev < 50:
		camera_anglev += changev
		rotate_x(deg_to_rad(changev))

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		fov = clamp(fov - zoom_speed, min_fov, max_fov)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		fov = clamp(fov + zoom_speed, min_fov, max_fov)	
