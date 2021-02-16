extends Node


var score: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func take_card(card):
	# quickly animate moving this card to the player's hand.
	pass
	
	# shift other cards to center everything if necessary
	pass

	yield(get_tree().create_timer(.1), "timeout")
