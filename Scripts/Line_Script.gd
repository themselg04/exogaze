extends MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var mesh_line = ImmediateMesh.new()
	mesh = mesh_line
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.WHITE_SMOKE
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	mesh_line.clear_surfaces()
	mesh_line.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, material)
	
