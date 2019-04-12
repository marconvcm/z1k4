extends Node

var database: Array

func _ready():
	awake()

func awake():
	var file = File.new()
	file.open("res://Database.json", File.READ)
	var json = file.get_as_text()
	database = JSON.parse(json).result
	file.close()

func item_at(index):
	if index > (Inventory.database.size()-1) || index < 0:
		return null
	return Inventory.database[index]