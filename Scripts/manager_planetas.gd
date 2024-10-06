extends Node3D

@onready var camara : Camera3D = get_node("../Camera3D")

var planetas_json = {
	"planetas": [
		{
			"nombre": "Tierra",
			"ascencion:recta": 1,
			"dec": 2,
			"distancia": 0,
			"textura": "res://Resources/PLANETS/tierra.jpg"
		},
		{
			"nombre": "Proxima Centauri b",
			"ascencion_recta": 217.42895,
			"dec": -62.6794,
			"distancia": 1295,
			"textura": "res://Resources/PLANETS/exo1.jpg"
		},
		{
			"nombre": "HD 189733 b",
			"ascencion_recta": 300.1821387,
			"dec": 22.7084,
			"distancia": 19.31588,
			"textura": "res://Resources/PLANETS/exo2.jpg"
		},
		{
			"nombre": "Kepler-16 B",
			"ascencion_recta": 289.075833,
			"dec": 51.75722,
			"distancia": 23.02122,
			"textura": "res://Resources/PLANETS/exo3.jpg"
		},
		{
			"nombre": "WASP-12b",
			"ascencion_recta": 97.636625,
			"dec": 29.67226,
			"distancia": 266.7432,
			"textura": "res://Resources/PLANETS/exo4.jpg"
		},
		{
			"nombre": "TRAPPIST-1 e",
			"ascencion_recta": 346.62083,
			"dec": -5.0434,
			"distancia": 12.0984,
			"textura": "res://Resources/PLANETS/exo5.jpg"
		}
	]
}
var planetas_instancias = []
var X_DESPLAZAMIENTO = 2.0
var planeta_seleccionado = 0

func _ready():
	
	# Verificar si se encontró la cámara
	if not camara:
		print("No se pudo encontrar la cámara en el nodo raíz")
	camara.position = Vector3(0, 0, 4)
	camara.rotation_degrees = Vector3(0, 0, 0)
	crear_planetas()
	planeta_seleccionado = 0

func crear_planetas():
	for i in range(planetas_json["planetas"].size()):
		var planeta_data = planetas_json["planetas"][i]
		var nuevo_planeta = instanciar_planeta(planeta_data)
		nuevo_planeta.position = obtener_posicion_inicial(i)
		planetas_instancias.append(nuevo_planeta)
	
	seleccionar_planeta(planeta_seleccionado)

func instanciar_planeta(planeta_data):
	var planeta_scene = preload("res://Scenes/planeta.tscn")
	var planeta = planeta_scene.instantiate()
	add_child(planeta)
	planeta.set_nombre(planeta_data["nombre"])
	planeta.set_textura(planeta_data["textura"])
	return planeta

func obtener_posicion_inicial(indice):
	return Vector3(indice * X_DESPLAZAMIENTO, 0, 0)

func seleccionar_planeta(indice):
	var tween = get_tree().create_tween()
	for i in range(planetas_instancias.size()):
		var planeta = planetas_instancias[i]
		if i == indice:
			planeta.escalar_planeta(1.5)
		else:
			planeta.escalar_planeta(1.0)
		tween.tween_property(camara, "position", Vector3(indice*X_DESPLAZAMIENTO,0,3), 1)

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_LEFT:
				if planeta_seleccionado == 0 :
					planeta_seleccionado = planetas_instancias.size() -1
					seleccionar_planeta(planeta_seleccionado)
				else :
					planeta_seleccionado = (planeta_seleccionado - 1) % planetas_instancias.size()
					seleccionar_planeta(planeta_seleccionado)
			KEY_RIGHT:
				planeta_seleccionado = (planeta_seleccionado + 1) % planetas_instancias.size()
				seleccionar_planeta(planeta_seleccionado)
			KEY_ENTER:
				cambiar_escena_planeta(planetas_json["planetas"][planeta_seleccionado])
				
func cambiar_escena_planeta(planeta):
	SceneManager.orrery_to_stelarium(planeta)
