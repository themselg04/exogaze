extends Node3D

var nombre: String = ""
var textura_path: String = ""
@onready var esfera: CSGSphere3D = $Mesh
@onready var etiqueta: Label3D = $Label3D

func _ready():
	if etiqueta:
		etiqueta.text = nombre
		etiqueta.pixel_size = 0.01  # Ajusta este valor según sea necesario
		etiqueta.position = Vector3(0, 1.5, 0)  # Coloca la etiqueta sobre el planeta

func set_nombre(nuevo_nombre: String) -> void:
	nombre = nuevo_nombre
	if etiqueta:
		etiqueta.text = nombre

func get_nombre() -> String:
	return nombre

func set_textura(path: String) -> void:
	randomize()
	textura_path = path
	
	if esfera:
		# Crear un nuevo material para cada esfera
		var nuevo_material = StandardMaterial3D.new()
		
		var texture = load(textura_path)
		if texture:
			nuevo_material.albedo_texture = texture
		else:
			# Asignar un color aleatorio si la textura no se encuentra
			var random_color = Color8(randi() % 256, randi() % 256, randi() % 256)  # Color único por cada invocación
			nuevo_material.albedo_color = random_color
		
		# Asignar el nuevo material a la esfera
		esfera.material_override = nuevo_material



func escalar_planeta(escala: float) -> void:
	self.scale = Vector3(escala, escala, escala)
	if etiqueta:
		# Mantener el tamaño de la etiqueta constante
		etiqueta.pixel_size = 0.01 / escala
		etiqueta.position = Vector3(0,1.5 / escala,0)

func _process(delta: float) -> void:
	rotate_y(delta * 0.5)
	if etiqueta:
		etiqueta.rotate_y(-delta * 0.5) # Compensar la rotación de la escena
