extends Node2D


var value


func _ready():
	value = 5
	yield(outer(), "completed")
	print(value)
	
	
func outer():
	value = 6
	yield(get_tree().create_timer(0), "timeout")



#func _move_sprite(sprite: Sprite, amount: float, time: float):
#	var tween: Tween = sprite.get_node("Tween")
#	var from = sprite.position
#	var to = sprite.position + Vector2(amount, 0)
#	tween.interpolate_property(sprite, "position", from, to, time)
#	tween.start()
#	return tween
#
#func _move_sprites(sprites: Array, amount: float, time: float):
#	var tweens = []
#	for sprite in sprites:
#		var tween = _move_sprite(sprite, amount, time)
#		tweens.append(tween)
#
#	return tweens
#
#
#func _ready():
#	var tween1 = _move_sprite($Sprite1, 100, 1)
#
#	var other_sprites = [$Sprite2, $Sprite3]
#	var other_tweens = _move_sprites(other_sprites, 100, 2)
#
#	for tween in other_tweens:
#		if tween.is_active():
#			yield(tween, "tween_completed")
#
#	print("waiting for tween1")
#
#	if tween1.is_active():
#		yield(tween1, "tween_completed")
#
#	print("done")
	
	

	
	
	

#func get_shift_card_tweens():
#	# space cards evenly and center them on x = 0
#	var spacing = 20
#	var left = -((cards.size() - 1) * 15 + 32) / 2
#
#	var tweens = []
#	for i in range(cards.size()):
#		var card = cards[i]
#		assert(card != _next_move)
#		var target = Vector2(left + spacing * i, 0)
#		var tween: Tween = card.get_node("Tween")
#		tween.interpolate_property(card, "position", card.position, target, .2)
#		tweens.append(tween)
#		tween.start()
#
#	return tweens
#
#
#func _on_tween_completed(_arg1, _arg2):
#	print("tah-dah!")
#
#
#func make_move():
#	# scooch up to the PlayPosition
#	var card = _next_move
#	var index = cards.find(_next_move)
#	cards.remove(index)
#
#	var play_tween: Tween = card.get_node("Tween")
#	play_tween.interpolate_property(card, "position", card.position, $PlayPosition.position, .2)
#	play_tween.connect("tween_completed", self, "_on_tween_completed")
#	play_tween.start()
#
#	var shift_tweens = get_shift_card_tweens()
#
#	card.reveal()
#
#	print("is play_tween active? ", play_tween.is_active())
#	print("runtime: ", play_tween.get_runtime())
#	if play_tween.is_active():
#		yield(play_tween, "tween_completed")
#	print("... done with play_tween")
#
#	print("waiting on shift_tweens...")
#	var n = 1
#	for tween in shift_tweens:
#		if tween.is_active():
#			print("waiting on shift_tween ", n, " / ", shift_tweens.size())
#			yield(tween, "tween_completed")
#	print("... done with shift_tweens")
