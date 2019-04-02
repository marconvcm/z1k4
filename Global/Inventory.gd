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