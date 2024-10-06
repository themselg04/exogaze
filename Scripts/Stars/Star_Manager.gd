extends Node

var temp_line 
var mode = "Creating"
var creating_constellation = []
var temp_constellation = []

var constellations = []
var visual_constellations = []

var temp_Star1
var temp_Star2

signal request_line(ID: int)
signal request_connection(line: Node3D, ID: int)

func _process(_delta):
	if Input.is_action_just_pressed("EndConstellation"):
		on_end()

func _ready():
	var nombre = SceneManager.json_planeta["nombre"]
	var stars_list = []
	for i in range(1,500):
		var new_star = instanciar_estrella()
		var id = randi()
		new_star.ID = id
		stars_list.append(new_star)
		add_child(new_star)
	for curr_star in stars_list:
		curr_star.position = random_pos()
		curr_star.scale = random_sca()
		var c_scalar = 1.0 / curr_star.scale.x
		curr_star.escalar_hitbox(c_scalar)
	for i in get_children():
		if i is Node3D:
			connect("request_line", i.connect_to_star)
			connect("request_connection", i.connect_line)

func instanciar_estrella():
	var star_scene = preload("res://Scenes/star.tscn")
	var star = star_scene.instantiate()
	return star

func random_pos() -> Vector3:
	var pos = [0.0,0.0,0.0]
	for i in range(0,3):
		pos[i] = 10*randf_range(-4.5,4.5)
		print(i)
	var res = Vector3(pos[0],pos[1],pos[2])
	var scaler = 10 / res.distance_to(Vector3(0.0,0.0,0.0))
	for i in range(0,3):
		pos[i] = pos[i] * scaler
		print(i)
	print(res)
	return res

func random_sca() -> Vector3:
	var rand = randf_range(0.05,0.075)
	var res = Vector3(rand,rand,rand)
	print(res)
	return res

func on_star_clicked(position: Transform3D, ID ):
	print("onstarclicked")
	if mode == "Creating":
		request_line.emit(ID)
		return
	if mode == "Connecting":
		request_connection.emit(temp_line, ID)
		return

func on_line(line: MeshInstance3D, ID):
	print("online")
	temp_line = line
	mode = "Connecting"
	temp_Star1 = ID

func on_connection(pos: Vector3, ID):
	creating_constellation.append(temp_line)
	temp_line = null
	temp_line = load("res://Scenes/Line.tscn").instantiate()
	find_child("Constellations").find_child("Creating").add_child(temp_line)
	temp_line.mesh.surface_add_vertex(pos)
	temp_Star2 = ID
	temp_constellation.append([temp_Star1, temp_Star2])

func on_end():
	if !temp_line :
		return 
	temp_line.queue_free()
	temp_line = null
	
	constellations.append(temp_constellation)
	temp_constellation = []
	
	var temp = []
	for i in find_child("Constellations").get_children():
		temp.append(i)
	visual_constellations.append(temp)
	
	
	mode = "Creating"
