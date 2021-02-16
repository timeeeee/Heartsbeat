extends Node2D


var scores: Dictionary
var round_number: int

var human_player
var players: Array

var is_hearts_broken: bool
var leads_next_trick  # Player enum value
var hands: Dictionary

var Card = preload("res://")


# Called when the node enters the scene tree for the first time.
func _ready():
	var cards = []
	# create cards!
	var suits2 = ["Spades", "Diamonds", "Clubs", "Hearts"]
	var ranks = [
		"Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
		"Ten", "Jack", "Queen", "King"
	]
	for suit in suits:
		for rank in ranks:
			card = load("res://")
			cards.append()
	
	human_player = null
	players = null
	play_game()
	

# play tricks until the someone has 100 points
func play_game():
	scores = {
		players.WEST: 0,
		players.NORTH: 0,
		players.EAST: 0,
		players.PLAYER: 0
	}
	
	round_number = 1
	
	while scores.values().max() < 100:
		yield(play_round(), "completed")
		
	# show who won
	pass
	
	# back to the menu
	
	
	
# deal a round, pass cards, play tricks until everyone's out of cards
func play_round():
	yield(deal(), "completed")
	

# animate cards 
func deal():
	pass
	
	
# ask players for their moves in the right order, and animate the results
func play_trick():
	
