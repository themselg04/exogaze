extends StaticBody3D

func _ready():
	input_ray_pickable = true
	connect("input_event", get_parent().on_mouse)
