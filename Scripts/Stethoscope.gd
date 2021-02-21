extends Node2D

class_name Stethoscope

var _is_dragged: bool
var _is_active: bool
var _original_position: Vector2


func _ready():
	_original_position = position
	deactivate()


func _input(event):
	# if we're being dragged, follow the mouse
	if event is InputEventMouseMotion and _is_dragged:
		var global_pos = get_viewport().get_mouse_position()
		position = get_parent().to_local(get_viewport().get_mouse_position())
		
	

# allow dragging
func activate():
	_is_active = true
	$InactiveSprite.visible = false
	$ActiveSprite.visible = true


# don't allow dragging
func deactivate():
	_is_active = false
	$InactiveSprite.visible = true
	$ActiveSprite.visible = false
	

func pick_up():
	print("stethoscope: pick up")
	if _is_active:
		_is_dragged = true
	
	
func drop():
	print("stethoscope: drop")
	_is_dragged = false
	position = _original_position


func _on_Area2D_input_event(viewport, event: InputEvent, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			pick_up()
		else:
			drop()
