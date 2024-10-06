extends Control

var mouse_last_position = Vector2()
var time_since_last_move = 0.0
var fade_delay = 2.0
var fade_speed = 8.0
var target_opacity = 1.0

func _ready() -> void:
	var nombre = SceneManager.json_planeta["nombre"]
	addPlanetName(nombre)
	mouse_last_position = get_viewport().get_mouse_position()
	modulate.a = 1.0
	#$OptionList.rect_position = Vector2(200, 0)  # Start with ItemList offscreen



func _process(delta):
	var current_mouse_position = get_viewport().get_mouse_position()
	
	if current_mouse_position != mouse_last_position:
		time_since_last_move = 0.0
		target_opacity = 1.0
		mouse_last_position = current_mouse_position
	else:
		time_since_last_move += delta
		
	if time_since_last_move > fade_delay:
		target_opacity = 0.0 # Start fading out

	modulate.a = lerp(modulate.a, target_opacity, fade_speed * delta)

func addPlanetName(planetName: String) -> void:
	$ShowPlanetName.clear()
	$ShowPlanetName.add_text(planetName)
	
func _on_button_pressed() -> void:
	SceneManager.stelarium_to_orrery()
	
