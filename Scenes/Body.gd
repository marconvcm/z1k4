extends KinematicBody

const GRAVITY = -9.6
const FLOOR_LEVEL = Vector3(0, 1, 0)
var direction = Vector3(0, 0, 0)

export var speed = 3
export var life = 4

func _process(delta):

	direction = direction.normalized()
	direction = direction.rotated(Vector3(0, 1, 0), rotation.y)

	if !is_on_floor():
		direction.y += GRAVITY 
	else:
		direction.y = 0
	
	move_and_slide(direction * speed, FLOOR_LEVEL)

func damage():
	if life <= -1: return 
	life = life - 1
	if(life <= 0):
		self.queue_free()