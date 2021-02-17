extends Node2D

class_name HeartsPlayer


var score: int
onready var cards: Array = []
var _show_cards = false
onready var _card_move_time = get_tree().get_root().get_node("Hearts").card_move_time
var _next_move: Card
var game


func _ready():
	game = get_tree().root.get_node("Hearts")
	
func is_there_any(suit: String) -> bool:
	for card in cards:
		if card.suit == suit:
			return true
			
	return false
		
	
	
func choose_move(_cards_so_far: Array):
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
		
	# start animating cards moving to correct positions
	var shift_tweens = get_shift_card_tweens()
	
	# quickly animate moving this card to the player's hand.
	var tween: Tween = card.get_node("Tween")
	tween.interpolate_property(card, "rotation_degrees", card.rotation_degrees, 0, _card_move_time)
	tween.start()
	
	for t in shift_tweens:
		yield(t, "tween_completed")
		
	# if this is the human player, show the cards
	if _show_cards:
		card.reveal()
		
		
func _animate_card(card: Card, to: Vector2) -> Tween:
	var tween: Tween = card.get_node("Tween")
	tween.remove_all()
	tween.interpolate_property(card, "position", card.position, to, _card_move_time)
	tween.start()
	return tween
	
	
func get_shift_card_tweens():
	# space cards evenly and center them on x = 0
	var spacing = 20
	var left = -((cards.size() - 1) * 15 + 32) / 2

	var tweens = []
	for i in range(cards.size()):
		var card = cards[i]
		assert(card != _next_move)
		var target = Vector2(left + spacing * i, 0)
		tweens.append(_animate_card(card, target))

	return tweens


func make_move():
	assert(_next_move != null)
	# scooch up to the PlayPosition
	var card = _next_move
	var index = cards.find(_next_move)
	cards.remove(index)

	_animate_card(card, $PlayPosition.position)

	get_shift_card_tweens()
	
	yield(get_tree().create_timer(_card_move_time), "timeout")
	
	card.reveal()
	_next_move = null


