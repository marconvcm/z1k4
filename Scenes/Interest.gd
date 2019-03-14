extends Area

onready var player = preload("res://Scenes/Player.tscn")

func _on_area_body_entered(body):
	if body.name.begins_with("Player"):
			body.enable_interact_with(self)