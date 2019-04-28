extends Node

var life: float = 1
var armor = null
var weapon = null
var support = null
var inventory = []

func _ready():
	inventory.append(Inventory.item_at(0))
	inventory.append(Inventory.item_at(1))
	weapon = Inventory.item_at(2)
	pass

func item_at(index):
	if index > (inventory.size()-1) || index < 0:
		return null
	return inventory[index]