extends Node2D

class_name Game

export var card_move_time: float
export var trick_delay: float

var scores: Dictionary
var round_number: int

var human_player
var players: Array

var is_first_trick: bool
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
	is_first_trick = true
	is_hearts_broken = false
	yield(deal(), "completed")
	yield($HumanPlayer.sort_cards(), "completed")
	
	for trick_number in range(13):
		print("trick number ", trick_number)
		yield(play_trick(), "completed")
		
	# move cards back from the pile to the deck
	for card in cards:
		$Pile.remove_child(card)
		$Deck.add_child(card)
		card.position = Vector2(0, 0)
		card.rotation = 0
		card.z_index = 0
	

# shuffle and animate cards 
func deal():
	cards.shuffle()

	# deal them to players (player.take_card(card))
	var i = 0
	for card in cards:
		card.z_index = 1
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
		print(player, " chose ", player._next_move)
		var card = player.get_move()
		yield(player.make_move(), "completed")
		cards_so_far.append(card)

	# set whoever took the trick as the leader for the next round
	var trick_suit = cards_so_far[0].suit
	var max_value = -1
	var max_card = null
	leads_next_trick = null
	for index in range(4):
		var card = cards_so_far[index]
		var player = players[(index + leader_index) % 4]
		if card.suit == "Hearts":
			is_hearts_broken = true
			
		if card.suit == trick_suit and card.value > max_value:
			leads_next_trick = player
			max_value = card.value
			max_card = card
			
	print(leads_next_trick, " won the trick with the ", max_card)
	
	yield(get_tree().create_timer(trick_delay), "timeout")

	# now actually take the cards from the players and hide them somewhere
	# move off screen...
	var target_node = leads_next_trick.get_node("TookTrickPosition")
	var global_target = leads_next_trick.to_global(target_node.position)
	for card in cards_so_far:
		var target = card.get_parent().to_local(global_target)
		var tween: Tween = card.get_node("Tween")
		tween.interpolate_property(card, "position", card.position, target, card_move_time)
		tween.start()
		
	print("waiting for cards to move offscreen")
	yield(get_tree().create_timer(card_move_time), "timeout")
	
	for card in cards_so_far:
		card.get_parent().remove_child(card)
		card.flip()
		$Pile.add_child(card)
		
	is_first_trick = false


