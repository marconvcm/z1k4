extends Control

var menu_index = 0

onready var inventory_grid = $Container/Middle/Inventory/Holder/Grid
onready var inventory_selector = $Container/Middle/Inventory/Holder/Grid/Slot1/Selector
onready var information = $Container/Middle/VBoxContainer/InformationViewRect/Information
onready var menu_animator = $Container/Middle/VBoxContainer/ItemViewRect/Animation

signal item_selection_index_changed

func _ready():
	setup_inventory()
	pass
	
#warning-ignore:unused_argument
func _process(delta):
	selector_movement()
	trigger_action()
	display_selector()

func selector_movement():
	var next_index = menu_index
	
	if Input.is_action_just_released("ui_right"):
		next_index = next_index + 1	
	if Input.is_action_just_released("ui_left"):
		next_index = next_index - 1	
	if Input.is_action_just_released("ui_down"):
		next_index = next_index + 2	
	if Input.is_action_just_released("ui_up"):
		next_index = next_index - 2
		
	if next_index < 8 && next_index > -1:
		menu_index = next_index
		emit_signal("item_selection_index_changed", menu_index)


func trigger_action():
	if Input.is_action_just_released("ui_accept"):
		menu_animator.play("CommandEnter")
	pass


func display_selector():
	var slot: TextureRect = inventory_grid.get_children()[menu_index]
	var last_slot = inventory_selector.get_parent()
	last_slot.remove_child(inventory_selector)
	slot.add_child(inventory_selector)

func setup_inventory():
	var i = 0
	while i < Inventory.database.size():
		setup_inventory_item(Inventory.database[i], i)
		i = i + 1

func setup_inventory_item(item, index):
	var holder: TextureRect = inventory_grid.get_children()[index]
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

func _on_menu_item_selection_index_changed(index):

	if index > (Inventory.database.size()-1):
		information.text = ""
		return

	var item = Inventory.database[index]
	information.text = item.information
