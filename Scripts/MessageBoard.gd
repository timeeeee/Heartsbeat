extends CanvasLayer

func _ready():
	pass
	
	
func show_message(message: String):
	$Label.text = message
	$Timer.start()
	
	
func _on_Timer_timeout():
	$Label.text = ""
