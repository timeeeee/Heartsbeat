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
		update_sounds()


# allow dragging
func activate():
	_is_active = true
	$InactiveSprite.visible = false
	$ActiveSprite.visible = true


# don't allow dragging
func deactivate():
	_is_active = false
	drop()
	$InactiveSprite.visible = true
	$ActiveSprite.visible = false
	

func pick_up():
	if _is_active:
		_is_dragged = true
	
	
func drop():
	_is_dragged = false
	position = _original_position
	update_sounds()
	
	
func update_sounds():
	# set all the card volumes!
	for card in get_tree().get_nodes_in_group("cards"):
		var c: Card = card
		c.set_listen_position(get_parent().to_global(position))


func _on_Area2D_input_event(viewport, event: InputEvent, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			pick_up()
		else:
			drop()
