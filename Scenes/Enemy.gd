extends "res://Scenes/Body.gd"

const NORMAL_VIEW = Vector3(8, 0.001, 8) 
const ALERT_VIEW = NORMAL_VIEW * 4

var stop = false
var player: KinematicBody = null

func _process(delta):
	if player != null:
		var diff = (player.translation - translation)
		$RayCast.cast_to = Vector3(diff.x, diff.z, 0)
		move()

func move():
	if !stop:
		var point = $RayCast.get_collision_point()
		direction = player.translation - Vector3(point.x, 0, point.z) 
		print(direction)

func _on_area_body_entered(body):
	if body.name == "Player":
		self.player = body
		$Area.scale = ALERT_VIEW

func _on_area_body_exited(body):
	if body.name == "Player":
		self.player = null
		$Area.scale = NORMAL_VIEW

func _on_attack_body_entered(body):
	if body.name == "Player":
		stop = true
		
func damage():
	$Area.scale = ALERT_VIEW
	.damage()