extends Node2D

class_name Card

var suit: String
var rank: String
var value: int
var suit_value: int
var rank_int: int
var suit_int: int
var is_face_up: bool
var max_stethoscope_distance = 100

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


var _suit_values = {
	"Spades": 0,
	"Diamonds": 1,
	"Clubs": 2,
	"Hearts": 3
}


func set_rank_and_suit(_rank: String, _suit: String):
	rank = _rank
	suit = _suit
	rank_int = _ranks[rank]
	suit_int = _suits[suit]
	value = _values[rank]
	suit_value = _suit_values[suit]
	
	$Face.region_rect = Rect2(
		Vector2(32 * rank_int + 1, 58 * suit_int + 1),
		Vector2(30, 56)
	)


func _ready():
	is_face_up = false
	$Face.set_visible(false)
	
	# choose a random beat and bpm
	var streams = [
		load("res://Sounds/beat.ogg"),
		load("res://Sounds/beat_low.ogg"),
		load("res://Sounds/beat_high.ogg")
	]
	
	$AudioStreamPlayer.stream = streams[randi() % streams.size()]
	var bpm = rand_range(60, 100)
	$BeatTrigger.wait_time = 60 / bpm;
	

# update volume based on stethoscope distance
func set_listen_position(listen_position: Vector2):
	if suit != "Hearts":
		return

	var global_pos = get_parent().to_global(position)
	var distance = listen_position.distance_to(global_pos)
		
	if distance < max_stethoscope_distance:
		# start beat and set volume based on distance
		if $BeatTrigger.is_stopped():
			$BeatTrigger.start()
		
		var factor = pow(1 - distance / max_stethoscope_distance, 4)
		$AudioStreamPlayer.volume_db = lerp(-40, 6, factor)
	else:
		# otherwise don't play the heartbeat
		$BeatTrigger.stop()

	
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


func _on_BeatTrigger_timeout():
	pass # Replace with function body.
