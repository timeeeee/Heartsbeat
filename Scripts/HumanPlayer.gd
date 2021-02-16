extends HeartsPlayer

func _ready():
	_show_cards = true

func choose_move(cards_so_far: Array):
	print("picking a move for the human player. HumanPlayer.choose_move not implemented")
	_next_move = cards[0]
	yield(get_tree().create_timer(.1), "timeout")
