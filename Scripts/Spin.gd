extends Sprite


export var speed: float = 200


func _process(delta):
	rotation_degrees += delta * speed
	if rotation_degrees > 360:
		rotation_degrees -= 360
