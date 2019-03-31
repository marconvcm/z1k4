extends Node

var data: Array

func _ready():
	awake()

func awake():
	var file = File.new()
	file.open("res://Inventory.json", File.READ)
	var json = file.get_as_text()
	data = JSON.parse(json).result
	file.close()
	pass
	
func display():
	
	pass