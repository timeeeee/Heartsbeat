extends Node2D


export var card_move_time: float

var scores: Dictionary
var round_number: int

var human_player
var players: Array

var is_hearts_broken: bool
var leads_next_trick: HeartsPlayer
var hands: Dictionary

var card_scene = preload("res://Scenes/Card.tscn")
var cards: Array


# Called when the node enters the scene tree for the first time.
func _ready():
	# create cards!
	var suits = ["Spades", "Diamonds", "Clubs", "Hearts"]
	var ranks = [
		"Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
		"Ten", "Jack", "Queen", "King"
	]
	for suit in suits:
		for rank in ranks:
			var card = card_scene.instance()
			card.set_rank_and_suit(rank, suit)
			cards.append(card)
			$Deck.add_child(card)
	
	players = [$HumanPlayer, $WestPlayer, $NorthPlayer, $EastPlayer]
	play_game()
	

# play tricks until the someone has 100 points
func play_game():
	for player in players:
		scores[player] = 0
	
	round_number = 1
	
	while scores.values().max() < 100:
		yield(play_round(), "completed")
		
	# show who won
	pass
	
	# back to the menu
	pass
	
	
# deal a round, pass cards, play tricks until everyone's out of cards
func play_round():
	yield(deal(), "completed")
	
	for trick_number in range(13):
		print("trick number", trick_number)
		yield(play_trick(), "completed")
		
	# move cards back from the pile to the deck
	for card in cards:
		$Pile.remove_child(card)
		$Deck.add_child(card)
		card.position = Vector2(0, 0)
		card.rotation = 0
	

# shuffle and animate cards 
func deal():
	cards.shuffle()

	# deal them to players (player.take_card(card))
	var i = 0
	for card in cards:
		var player = players[i % 4]
		if card.rank == "Two" and card.suit == "Clubs":
			leads_next_trick = player
		yield(player.take_card(card), "completed")
		i += 1

	
# ask players for their moves in the right order, and animate the results
func play_trick():
	var leader_index = players.find(leads_next_trick)
	var cards_so_far = []
	for i in range(4):
		var player = players[(i + leader_index) % 4]
		
		# get move from this player
		yield(player.choose_move(cards_so_far), "completed")
		var card = player.get_move()
		yield(player.make_move(), "completed")
		cards_so_far.append(card)
		
	# set whoever took the trick as the leader for the next round
	print("setting new leader not implemented")
	leads_next_trick = players[randi() % 4]

	# now actually take the cards from the players and hide them somewhere
	print("hiding cards")
	for player in players:
		var card = player.remove_card()
		player.remove_child(card)
		card.flip()
		$Pile.add_child(card)
	
static func is_valid(cards_so_far: Array, card: Card) -> bool:
	return true

