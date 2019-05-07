extends Area

var current_hud: Node = null
onready var Hud = preload("res://Scenes/InGameHud.tscn")

export var is_door: bool = false
export var next_scene_path: String = ""
export var is_item: bool = false
export var item_id: String = ""

func _on_area_body_entered(body):
	if body.name.begins_with("Player"):
			body.enable_interact_with(self)

func _on_area_body_exited(body):
	if body.name.begins_with("Player"):
			body.disable_interact_with(self)

func destroy():
	queue_free()

func inspect():
	if self.is_door:
		get_tree().change_scene(next_scene_path)
		return
	
	if($Timer.is_stopped()):
		current_hud = Hud.instance()
		get_tree().get_root().add_child(current_hud)
		$Timer.start()

func _on_timer_timeout():
	if(self.current_hud):
		self.current_hud.queue_free()
