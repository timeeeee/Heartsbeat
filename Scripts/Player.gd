extends Node2D

class_name HeartsPlayer


var score: int
onready var cards: Array = []
var _show_cards = false
var _card_move_time: float
var _next_move: Card


func _ready():
	_card_move_time = get_tree().get_root().get_node("Hearts").card_move_time
	
	
func choose_move(cards_so_far: Array):
	yield()
	
	
func get_move() -> Card:
	return _next_move
	
	
func take_card(card: Node2D):
	cards.append(card)
	card.z_index = cards.size()
	
	# reparent the card to the player
	var global_pos = card.global_position
	var global_rotation = card.global_rotation
	card.get_parent().remove_child(card)
	add_child(card)
	card.position = card.to_local(global_pos)
	card.rotation = global_rotation - self.rotation
	
	# if this is the human player, show the cards
	if _show_cards:
		card.reveal()
	
	# quickly animate moving this card to the player's hand.
	var tween: Tween = card.get_node("Tween")
	tween.remove_all()
	tween.interpolate_property(card, "position", card.position, Vector2(0, 0), _card_move_time)
	tween.interpolate_property(card, "rotation_degrees", card.rotation_degrees, 0, _card_move_time)
	tween.start()
	yield(tween, "tween_completed")
	
	# shift other cards to center everything if necessary
	pass
	
	
func shift_cards():
	print("Player.shift_cards is not implemented")
	yield(get_tree().create_timer(_card_move_time), "timeout")


func make_move():
	# scooch up to the PlayPosition
	var card = _next_move
	var tween: Tween = card.get_node("Tween")
	tween.remove_all()
	tween.interpolate_property(card, "position", card.position, $PlayPosition.position, _card_move_time)
	tween.start()
	yield(tween, "tween_completed")
	card.reveal()
		
	yield(shift_cards(), "completed")
	
	
func remove_card():
	var index = cards.find(_next_move)
	cards.remove(index)
	return _next_move
	
