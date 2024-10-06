extends Node

# Globales 
var current_scene = null
var stelariunm = preload("res://Scenes/Stelarium.tscn").instantiate()
var smokescreen = preload("res://Scenes/smokescreen.tscn").instantiate()

# Organos
var json_planeta

# Organos screen manager
signal scene_has_loaded

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)

func _deferred_switch_scene(res_path):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func free_scene(scene_path):
	call_deferred("_deferred_free_scene", scene_path)

func _deferred_free_scene(scene_path):
	get_node(scene_path).free()

func check_instance():
	if (!is_instance_valid(smokescreen)):
		smokescreen = preload("res://Scenes/smokescreen.tscn").instantiate()

func orrery_to_stelarium(planeta):
	# Nos aseguramos de la existencia de smokescreen
	check_instance()
	var root = get_tree().root
	# Agregamos a smokescreen como hijo de la raiz actual
	root.add_child(smokescreen)
	# Iniciamos temporizador
	await get_tree().create_timer(1.0).timeout
	# Cargamos datos de orrery, y cambiamos de escena
	json_planeta = planeta
	switch_scene("res://Scenes/Stelarium.tscn")
	# Ponemos un temporizador
	await get_tree().create_timer(1.0).timeout
	# Liberamos smokescreen para no ver todo negro
	free_scene(smokescreen.get_path()) 
	# Emitimos señal positiva de que se termino de cargar la escena
	scene_has_loaded.emit()
	
func stelarium_to_orrery():
	# Nos aseguramos de la existencia de smokescreen
	check_instance()
	var root = get_tree().root
	# Agregamos a smokescreen como hijo de la raiz actual
	root.add_child(smokescreen)
	# Iniciamos temporizador
	await get_tree().create_timer(1.0).timeout
	# Cambiamos de escena
	switch_scene("res://Scenes/orrery.tscn")
	# Ponemos un temporizador
	await get_tree().create_timer(1.0).timeout
	# Liberamos smokescreen para no ver todo negro
	free_scene(smokescreen.get_path()) 
	# Emitimos señal positiva de que se termino de cargar la escena
	scene_has_loaded.emit()
