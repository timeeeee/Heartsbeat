extends CanvasLayer

class_name ScoreBoard

signal next_round

var players: Array
var score_grid: GridContainer
onready var win_label: Label = $Panel/WinLabel

func _ready():
	# get player nodes
	var hearts = get_tree().root.get_node("Hearts")
	players = []
	for player_name in ["HumanPlayer", "WestPlayer", "NorthPlayer", "EastPlayer"]:
		players.append(hearts.get_node(player_name))

	score_grid = $Panel/ScoreTable/ScoreGrid
	
	$Panel.visible = false


# render scores from a list of dictionaries
func show_scores(scores):
	$Panel.visible = true
	
	# render scores from a list of dictionaries
	for label in score_grid.get_children():
		label.visible = false

	var game = get_tree().root.get_node("Hearts")
	var score_labels = $Panel/ScoreTable/ScoreGrid.get_children()
	var round_number = 1
	var totals = Dictionary()
	for player in players:
		totals[player] = 0
	
	# show scores for rounds so far
	for round_scores in scores:
		# make the round number visible in this row
		score_grid.get_child((round_number - 1) * 5).visible = true
		
		for i in range(4):
			var player = players[i]
			totals[player] += round_scores[player]
			var label_index = (round_number - 1) * 5 + i + 1
			var label = score_grid.get_child(label_index)
			label.text = str(round_scores[player])
			label.visible = true
			
		round_number += 1
		
	# display totals
	var total_labels = $Panel/ScoreTable/Totals.get_children()
	for i in range(4):
		var player = players[i]
		var label = total_labels[i + 1]
		label.text = str(totals[player])

	# is the game over?
	if totals.values().max() >= 100:
		win_label.visible = true
		var min_score = totals.values().min()
		var win_player_names = []
		for player in players:
			if totals[player] == min_score:
				win_player_names.append(player.name)
				
		win_label.text = get_win_message(win_player_names)
		
		$Panel/MenuButton.visible = true
		$Panel/NextRoundButton.visible = false
	else:
		$Panel/WinLabel.visible = false
		$Panel/MenuButton.visible = false
		$Panel/NextRoundButton.visible = true
		
		
func get_win_message(win_player_names: Array):
	if win_player_names.size() == 1:
		return "{player} wins!".format({"player": win_player_names[0]})
	else:
		var msg = ""
		for player_name in win_player_names.slice(0, -3):
			msg += player_name + ", "
		
		msg += win_player_names[-2] + " and " + win_player_names[-1] + " tie."
		return msg


func _on_NextRoundButton_pressed():
	emit_signal("next_round")
	$Panel.visible = false


func _on_MenuButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
