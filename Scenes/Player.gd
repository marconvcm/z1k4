extends KinematicBody

const SPEED = 10
const GRAVITY = -9.6
const FLOOR_LEVEL = Vector3(0, 1, 0)
var direction = Vector3(0, 0, 0)

onready var Damage = preload("res://Scenes/Damage.tscn") # Will load when parsing the script.

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
		_rotation += 1 * 5

	if Input.is_action_pressed("ui_right"): 
		_rotation -= 1 * 5

	if Input.is_action_pressed("ui_up"): 
		direction.z += 1

	if Input.is_action_pressed("ui_down"): 
		direction.z -= 1
		speed /= 2 
		
	$Pointer.visible = Input.is_action_pressed("wield")
	
	if $Pointer.visible && Input.is_action_pressed("ui_accept") && shoot == 1:
		shoot($RayCast.get_collision_point())
	
	rotate_y(_rotation * delta)
	
	direction = direction.normalized()
	direction = direction.rotated(Vector3(0, 1, 0), rotation.y)
	
	if !is_on_floor():
		direction.y += GRAVITY 
	
	move_and_slide(direction * speed, FLOOR_LEVEL)

func adjust_fire_area():
	if $RayCast.is_colliding():
		var node = $RayCast.get_collider()
		if node == null: 
			return 
		if node.name.begins_with("Enemy"):
			current_enemy = node
	else:
		current_enemy = null

func coldown():
	shoot = 1
	damage.queue_free()
	pass

func enable_interact_with(body):
	print(body)

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