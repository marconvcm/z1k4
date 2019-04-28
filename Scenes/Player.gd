extends KinematicBody

const SPEED = 10
const GRAVITY = -9.6
const FLOOR_LEVEL = Vector3(0, 2, 0)
var direction = Vector3(0, 0, 0)
var interest_point = null

export var life = 10

onready var Damage = preload("res://Scenes/Damage.tscn")
onready var Hud = preload("res://Scenes/InGameHud.tscn")
onready var Menu = preload("res://Scenes/Menu.tscn")

var shoot = 1;
var damage = null
var current_enemy = null

func _ready():
	$Timer.connect("timeout", self, "coldown")
	pass

func _process(delta):

	adjust_fire_area()
	
	var speed = SPEED
	var _rotation = 0
	direction = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("ui_left"):
		_rotation += 1 * 2

	if Input.is_action_pressed("ui_right"): 
		_rotation -= 1 * 2

	if Input.is_action_pressed("ui_up"): 
		direction.z += 1

	if Input.is_action_pressed("ui_down"): 
		direction.z -= 1
		speed /= 2 
		
	$Pointer.visible = Input.is_action_pressed("wield")
	
	if $Pointer.visible && Input.is_action_pressed("ui_accept") && shoot == 1:
		shoot($RayCast.get_collision_point())
	
	interact_with_interest()
	if Input.is_action_pressed("wield"):
		rotate_y(_rotation * 0.2 * delta)
	else: 
		rotate_y(_rotation * delta)
	
	direction = direction.normalized()
	direction = direction.rotated(Vector3(0, 1, 0), rotation.y)
	
	if !is_on_floor():
		direction.y += GRAVITY 
	
	move_and_slide(direction * speed, FLOOR_LEVEL)
	
	
	handle_menu()
	
func handle_menu():
	if Input.is_action_just_pressed("ui_cancel"):
		var menu = Menu.instance()
		menu.in_game_menu = true
		get_parent().add_child(menu)
		get_tree().paused = true 

func adjust_fire_area():
	current_enemy = null
	if $RayCast.is_colliding():
		var node = $RayCast.get_collider()
		if node == null: 
			return 
		if node.name.begins_with("Enemy"):
			current_enemy = node
			
func interact_with_interest():
	if interest_point != null && Input.is_action_just_pressed("ui_accept"):
		interest_point.inspect()

func coldown():
	shoot = 1
	damage.queue_free()
	pass

func enable_interact_with(body):
	interest_point = body
	
func disable_interact_with(body):
	interest_point = null

func shoot(position):
	$Audio.play()
	shoot = 0;
	damage = Damage.instance()
	get_parent().add_child(damage)
	damage.global_translate(position)
	if(current_enemy != null):
		current_enemy.damage()
		if(current_enemy.life <= 0):
			current_enemy = null
	$Timer.start()