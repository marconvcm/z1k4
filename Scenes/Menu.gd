extends Control

onready var inventoryGrid = $Container/Middle/Inventory/Holder/Grid

func _ready():
	setup_inventory()	
	pass
	
func setup_inventory():
	var i = 0
	while i < Inventory.data.size():
		setup_inventory_item(Inventory.data[i], i)
		i = i + 1

func setup_inventory_item(item, index):
	var holder: TextureRect = inventoryGrid.get_children()[index]
	holder.add_child(prepare_item(item))
	if item.amount > 1:
		holder.add_child(prepare_label(item))

func prepare_item(item):
	var icon = TextureRect.new()
	icon.rect_size = Vector2(80,80)
	icon.rect_position = Vector2(10,10)
	icon.texture = load("res://Resources/Assets/Items/" + item.icon)
	icon.name = "Icon"
	icon.expand = true
	return icon

func prepare_label(item):
	var label = Label.new()
	label.rect_size = Vector2(95,14)
	label.rect_position = Vector2(0,80)
	label.align = Label.ALIGN_RIGHT
	label.text = String(int(item.amount))
	return label