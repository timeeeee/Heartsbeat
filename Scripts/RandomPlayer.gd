extends HeartsPlayer

export var player_name: String


func choose_move(cards_so_far: Array):
	# if this is the first card of the first trick, play two of clubs
	if game.is_first_trick and cards_so_far.empty():
		var two_of_clubs = null
		for card in cards:
			if card.rank == "Two" and card.suit == "Clubs":
				two_of_clubs = card
				break
				
		_next_move = two_of_clubs
		yield(get_tree().create_timer(0), "timeout")
		return
		
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
				
	assert(valid_cards.size() > 0)
	_next_move = valid_cards[randi() % valid_cards.size()]
	yield(get_tree().create_timer(0), "timeout")


func _to_string():
	return player_name
