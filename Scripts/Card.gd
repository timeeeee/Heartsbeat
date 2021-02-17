extends Node2D

class_name Card

var suit: String
var rank: String
var value: int
var rank_int: int
var suit_int: int
var is_face_up: bool

var _values = {
	"Ace": 12,
	"Two": 0,
	"Three": 1,
	"Four": 2,
	"Five": 3,
	"Six": 4,
	"Seven": 5,
	"Eight": 6,
	"Nine": 7,
	"Ten": 8,
	"Jack": 9,
	"Queen": 10,
	"King": 11,
}

var _ranks = {
	"Ace": 0,
	"Two": 1,
	"Three": 2,
	"Four": 3,
	"Five": 4,
	"Six": 5,
	"Seven": 6,
	"Eight": 7,
	"Nine": 8,
	"Ten": 9,
	"Jack": 10,
	"Queen": 11,
	"King": 12,
}

# what order the suits are in in the texture
var _suits = {
	"Clubs": 0,
	"Spades": 1,
	"Hearts": 2,
	"Diamonds": 3
}


func set_rank_and_suit(_rank: String, _suit: String):
	rank = _rank
	suit = _suit
	rank_int = _ranks[rank]
	suit_int = _suits[suit]
	value = _values[_rank]
	
	$Face.region_rect = Rect2(
		Vector2(32 * rank_int + 1, 58 * suit_int + 1),
		Vector2(30, 56)
	)


func _ready():
	is_face_up = false
	$Face.set_visible(false)

	
func flip():
	if not is_face_up:
		$Face.set_visible(true)
		$Back.set_visible(false)
		is_face_up = true
	else:
		$Face.set_visible(false)
		$Back.set_visible(true)
		is_face_up = false
		
		
func reveal():
	if not is_face_up:
		flip()
	
	
func _to_string():
	var template = "{rank} of {suit}"
	return template.format({"rank": rank, "suit": suit})
