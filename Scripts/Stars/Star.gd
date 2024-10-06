extends Node3D

signal clicked(this_transform, ID)
signal created_line(line: Node, ID)
signal line_connected(Vector3, ID)

@export var ID: int

func _ready():
	# Por implementar : asignar color y brillo basandose en la BD
	connect("clicked", get_parent().on_star_clicked)
	connect("created_line", get_parent().on_line)
	connect("line_connected", get_parent().on_connection)

func escalar_hitbox(scalar) -> void:
	$StaticBody3D/CollisionShape3D.scale = Vector3(scalar,scalar,scalar)
	pass

func on_mouse(_camera, event :InputEvent, _pos, _normal, _shape_idx):
	print("hola")
	if event.is_action_pressed("Click"):
		clicked.emit(transform, ID)

func connect_to_star(inc_ID):
	if inc_ID == ID:
		var line = load("res://Scenes/Line.tscn").instantiate()
		get_parent().find_child("Constellations").find_child("Creating").add_child(line)
		
		line.mesh.surface_add_vertex(transform.origin)
		
		created_line.emit(line, ID)

func connect_line(line: Node3D, inc_ID):
	if inc_ID == ID:
		line.mesh.surface_add_vertex(transform.origin)
		line.mesh.surface_end()
		line_connected.emit(transform.origin, ID)
		
