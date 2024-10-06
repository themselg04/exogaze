extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_hover"))
	connect("mouse_exited", Callable(self, "_on_mouse_exit")) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_hover():
	$OptionList/AnimationPlayer.play("show_list")

func _on_mouse_exit():
	$OptionList/AnimationPlayer.play("hide_list")
