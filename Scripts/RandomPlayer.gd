extends HeartsPlayer




func choose_move(cards_so_far: Array):
	_next_move = cards[randi() % cards.size()]
	yield(get_tree().create_timer(0), "timeout")
