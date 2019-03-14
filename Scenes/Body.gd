extends KinematicBody

const SPEED = 10
const GRAVITY = -9.6
const FLOOR_LEVEL = Vector3(0, 1, 0)
var direction = Vector3(0, 0, 0)

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var life = 4

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	
	var speed = SPEED
	var _rotation = 0
	direction = Vector3(0, 0, 0)
	
	direction = direction.normalized()
	direction = direction.rotated(Vector3(0, 1, 0), rotation.y)
	
	if !is_on_floor():
		direction.y += GRAVITY 
	
	move_and_slide(direction * speed, FLOOR_LEVEL)

func damage():
	life = life - 1
	if(life <= 0):
		self.queue_free() 