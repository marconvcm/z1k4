extends Area

func _ready():
	connect("body_entered", self, "enable_camera")
	
func enable_camera(body):
	
	if body.name != "Player": 
		return
	print(body)
	if has_node("Camera"):
		var camera = get_node("Camera")
		camera.make_current()