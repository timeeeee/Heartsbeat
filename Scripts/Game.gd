extends Node2D


var scores: Dictionary
var round_number: int

var human_player
var players: Array

var is_hearts_broken: bool
var leads_next_trick  # Player enum value
var hands: Dictionary

var card_scene = preload("res://Scenes/Card.tscn")
var cards: Array

var leader


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
			card.reveal()
	
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
	

# shuffle and animate cards 
func deal():
	cards.shuffle()

	# deal them to players, with animations (player.take_card(card))
	pass
	
	# set the leader based on who has the two of clubs
	pass

	yield(get_tree().create_timer(.1), "timeout")
	
	
	
# ask players for their moves in the right order, and animate the results
func play_trick():
	var leader_index = players.find(leader)
	for i in range(4):
		var player = players[(i + leader_index) % 4]
		
		# get move from this player
		pass
		
		# animate it
		yield(get_tree().create_timer(.1), "timeout")
	
	
