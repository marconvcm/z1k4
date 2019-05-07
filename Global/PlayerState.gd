extends Node

var life: float = 1
var armor = null
var weapon = null
var support = null
var inventory = []

func _ready():
	inventory.append(Inventory.item_at(0))
	inventory.append(Inventory.item_at(1))
	armor = self.item_at(1)
	support = Inventory.item_at(8)
	pass

func item_at(index):
	if index > (inventory.size()-1) || index < 0:
		return null
	return inventory[index]

func add_item(item):
	inventory.append(item)

func equipe_weapon(item):
	weapon = item

func can_shoot():
	return weapon != null && weapon.ammo_load > 0

func shoot():
	weapon.ammo_load = weapon.ammo_load - 1