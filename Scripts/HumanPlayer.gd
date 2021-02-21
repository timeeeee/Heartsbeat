extends HeartsPlayer

signal card_was_clicked(card)

export var player_name: String
var message_board: MessageBoard
var stethoscope: Stethoscope


func _ready():
	_show_cards = true
	message_board = get_node("../MessageBoard")
	stethoscope = $Stethoscope
	

func choose_move(cards_so_far: Array):
	stethoscope.activate()
	var card
	while true:
		# get a potential move, then see if it's valid
		card = yield(self, "card_was_clicked")

		# if it's leading the first trick, must be 2 of clubs
		if game.is_first_trick and cards_so_far.size() == 0 and (card.suit != "Clubs" or card.rank != "Two"):
			message_board.show_message("Please lead the first trick with Two of Clubs")
			continue
			
		# are we leading with a heart before they're broken?
		if cards_so_far.size() == 0 and card.suit == "Hearts" and not game.is_hearts_broken:
			message_board.show_message("Hearts isn't broken yet!")
			continue
			
		# can we match the leading suit, but we're not?
		if cards_so_far.size() > 0:
			var leading_suit = cards_so_far[0].suit
			if card.suit != leading_suit and is_there_any(leading_suit):
				message_board.show_message("Please play a {suit}".format({"suit": leading_suit.trim_suffix("s")}))
				continue
			
		# if all that checks out, this is a valid move
		_next_move = card
		break
		
	stethoscope.deactivate()
		

func _is_card_less_than(card1: Card, card2: Card):
	if card1.suit_value < card2.suit_value:
		return true
	elif card1.suit_value > card2.suit_value:
		return false
	else:
		return card1.rank_int < card2.rank_int


func _to_string():
	return player_name


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		# which cards were clicked on?
		var top_card = null
		for card in cards:
			var sprite = card.get_node("Face")
			var local_position = sprite.to_local(event.position)
			if sprite.get_rect().has_point(local_position):
				if top_card == null or card.z_index > top_card.z_index:
					top_card = card
					
		if top_card != null:
			print(top_card, " was clicked")
			emit_signal("card_was_clicked", top_card)
