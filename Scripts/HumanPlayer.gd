extends HeartsPlayer

signal card_was_clicked(card)

export var player_name: String

func _ready():
	_show_cards = true
	

func choose_move(cards_so_far: Array):
	var valid_cards = []
	if cards_so_far.empty():  # if we're leading...
		for card in cards:
			if card.suit != "Hearts" or game.is_hearts_broken:
				valid_cards.append(card)
	else:  # must match leading suit
		var leading_suit = cards_so_far[0].suit
		if is_there_any(leading_suit):  # if we have one of these we have to play it
			for card in cards:
				if card.suit == leading_suit:
					valid_cards.append(card)
		else:  # if we don't have one we can play whatever
			valid_cards = cards.duplicate()
			
	# if this is the first card of the first trick, only valid card is two of clubs
	if game.is_first_trick and cards_so_far.empty():
		var two_of_clubs = null
		for card in cards:
			if card.rank == "Two" and card.suit == "Clubs":
				two_of_clubs = card
				break
				
		valid_cards = [two_of_clubs]

	assert(valid_cards.size() > 0)
	_next_move = null
	while not valid_cards.has(_next_move):
		_next_move = yield(self, "card_was_clicked")
		

func _is_card_less_than(card1: Card, card2: Card):
	if card1.suit_value < card2.suit_value:
		return true
	elif card1.suit_value > card2.suit_value:
		return false
	else:
		return card1.rank_int < card2.rank_int
	
		
func sort_cards():
	var new_order = cards.duplicate()
	new_order.sort_custom(self, "_is_card_less_than")
	for index in range(cards.size()):
		var old_card = cards[index]
		var new_card = new_order[index]
		new_card.z_index = index
		var tween: Tween = new_card.get_node("Tween")
		tween.interpolate_property(new_card, "position", new_card.position, old_card.position, _card_move_time)
		tween.start()
		
	cards = new_order
	yield(get_tree().create_timer(_card_move_time), "timeout")


func _to_string():
	return player_name


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		# which cards were clicked on?
		var top_card = null
		var max_z_index = -1
		for card in cards:
			var sprite = card.get_node("Face")
			var local_position = sprite.to_local(event.position)
			if sprite.get_rect().has_point(local_position):
				if top_card == null or card.z_index > top_card.z_index:
					top_card = card
					
		if top_card != null:
			print(top_card, " was clicked")
			emit_signal("card_was_clicked", top_card)
