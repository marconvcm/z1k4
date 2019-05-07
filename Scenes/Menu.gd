extends Control

var menu_index = 0
var command_index = 0

var current_menu_state = MENU_STATE.INVENTORY_STATE 

var current_item = null
var in_game_menu = false

onready var inventory_grid = $Container/Middle/Inventory/Holder/Grid
onready var inventory_selector = $Container/Middle/Inventory/Holder/Grid/Slot1/Selector
onready var information = $Container/Middle/VBoxContainer/InformationViewRect/Information
onready var menu_animator = $Container/Middle/VBoxContainer/ItemViewRect/Animation

onready var weapon_slot = $Container/Top/Weapon/Slot
onready var support_slot = $Container/Top/Support/Slot
onready var armor_slot = $Container/Top/Armor/Slot

onready var command_menu = $Container/Middle/VBoxContainer/ItemViewRect/CommandMenu
onready var command_menu_container = $Container/Middle/VBoxContainer/ItemViewRect/CommandMenu/VBoxContainer/
onready var command_menu_selector = $Container/Middle/VBoxContainer/ItemViewRect/CommandMenu/VBoxContainer/Item/Selector
onready var menu_select_sound: AudioStreamPlayer = $MenuSelect
onready var menu_click_sound: AudioStreamPlayer = $MenuClick
onready var menu_cancel_sound: AudioStreamPlayer = $MenuCancel

enum MENU_STATE {
	INVENTORY_STATE,
	COMMAND_STATE,
	EQUIPAMENT_STATE,
	OPTION_STATE
}


signal item_selection_index_changed

func _ready():
	setup_inventory()
	display_weapon()
	display_armor()
	display_support()
	pass

func _process(delta):
	
	match(current_menu_state):
		MENU_STATE.INVENTORY_STATE:
			menu_selector_movement()
			display_selector()
		MENU_STATE.COMMAND_STATE:
			command_selector_movement()
			display_command_selector()

	trigger_action()
	trigger_cancel()

func trigger_cancel():
	if Input.is_action_just_pressed("ui_cancel"):
		match(current_menu_state):
			MENU_STATE.INVENTORY_STATE:
				exit_menu()
			MENU_STATE.COMMAND_STATE:
				exit_command_list()

func exit_command_list():
	if current_item && !menu_animator.is_playing():
		current_item = null
		command_menu.visible = false
		menu_cancel_sound.play()
		current_menu_state = MENU_STATE.INVENTORY_STATE

func exit_menu():
	if in_game_menu:
		get_tree().paused = false
		self.queue_free()

func menu_selector_movement():
	
	if current_item != null: return
	
	var next_index = menu_index
	
	if Input.is_action_just_released("ui_right"):
		next_index = next_index + 1	
	if Input.is_action_just_released("ui_left"):
		next_index = next_index - 1	
	if Input.is_action_just_released("ui_down"):
		next_index = next_index + 2	
	if Input.is_action_just_released("ui_up"):
		next_index = next_index - 2
	
	if next_index != menu_index:
		menu_select_sound.play()
		
	if next_index < 8 && next_index > -1:
		menu_index = next_index
		emit_signal("item_selection_index_changed", menu_index)

func command_selector_movement():
	if current_item != null: 
		var next_index = command_index
		if Input.is_action_just_released("ui_down"):
			next_index = next_index + 1	
		if Input.is_action_just_released("ui_up"):
			next_index = next_index - 1
		if command_index != next_index:
			menu_select_sound.play()
		if next_index < 4 && next_index > -1:
			command_index = next_index

func display_weapon():
	clean_node(weapon_slot)
	if PlayerState.weapon != null && weapon_slot.get_children().size() == 0:
		var icon = prepare_item(PlayerState.weapon, Vector2(80, 80), Vector2(25, 20))
		var label = prepare_label(PlayerState.weapon, "ammo_load")
		weapon_slot.add_child(icon)
		weapon_slot.add_child(label)
		
func display_support():
	clean_node(support_slot)
	if PlayerState.support != null && support_slot.get_children().size() == 0:
		var icon = prepare_item(PlayerState.support, Vector2(80, 80), Vector2(25, 20))
		support_slot.add_child(icon)
		
func display_armor():
	clean_node(armor_slot)
	if PlayerState.armor != null && armor_slot.get_children().size() == 0:
		var icon = prepare_item(PlayerState.armor, Vector2(80, 80), Vector2(25, 20))
		armor_slot.add_child(icon)

func trigger_command_action():
	
	if current_item != null && command_index == 0:
		match current_item.type:
			"weapon":
				print(current_item.type)
				PlayerState.equipe_weapon(current_item)
				display_weapon()
				exit_command_list()

func display_command_selector():
	if current_item != null: 
		var slot: TextureRect = command_menu.get_child(0).get_children()[command_index]
		var last_slot = command_menu_selector.get_parent()
		if slot != last_slot:
			last_slot.remove_child(command_menu_selector)
			slot.add_child(command_menu_selector)
	pass

func trigger_action():
	if Input.is_action_just_released("ui_accept"):
		match(current_menu_state):
			MENU_STATE.INVENTORY_STATE:
				var item = PlayerState.item_at(menu_index)
				if item == null: return 
				refresh_command_menu(item)
				menu_animator.play("CommandEnter")
				current_item = item
				menu_click_sound.play()
				current_menu_state = MENU_STATE.COMMAND_STATE
			MENU_STATE.COMMAND_STATE:
				trigger_command_action()
				pass
	
	
func refresh_command_menu(item):
	var children = command_menu_container.get_children()
	var commands = [] #Utils.get_item_commands(item)
	var index = 0
	
	for key in commands: 
		var command_item_label: Label = children[index].get_child(0)
		command_item_label.text = commands[key]
		index = index + 1
	pass

func display_selector():
	var slot: TextureRect = inventory_grid.get_children()[menu_index]
	var last_slot = inventory_selector.get_parent()
	last_slot.remove_child(inventory_selector)
	slot.add_child(inventory_selector)

func setup_inventory():
	var i = 0
	while i < PlayerState.inventory.size():
		setup_inventory_item(PlayerState.inventory[i], i)
		i = i + 1

func setup_inventory_item(item, index):
	var holder: TextureRect = inventory_grid.get_children()[index]
	holder.add_child(prepare_item(item))
	if item.type == "weapon":
		holder.add_child(prepare_label(item, 'ammo_load'))
	if item.amount > 1:
		holder.add_child(prepare_label(item))
	
	
func prepare_item(item, rect_size = Vector2(80, 80), rect_position = Vector2(10,10)):
	var icon = TextureRect.new()
	icon.rect_size = rect_size
	icon.rect_position = rect_position
	icon.texture = load("res://Resources/Assets/Items/" + item.icon)
	icon.name = "Icon"
	icon.expand = true
	return icon

func prepare_label(item, key = "amount", position = Vector2(0,80)):
	var label = Label.new()
	label.rect_size = Vector2(95,14)
	label.rect_position = position
	label.align = Label.ALIGN_RIGHT
	label.text = String(int(item[key]))
	return label

func _on_menu_item_selection_index_changed(index):
	var item = PlayerState.item_at(index)
	if item == null:
		information.text = ""
		return
	information.text = item.label

func clean_node(node: Node):
	for child in node.get_children():
			child.queue_free()