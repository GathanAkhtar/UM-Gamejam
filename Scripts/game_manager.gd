extends Node

var score = 0
var total_supplies = 7
var all_collected = false

@onready var score_label: Label = $UI/ScoreLabel

func add_point():
	score += 1
	score_label.text = "Supplies Found: " + str(score)
	
	if score >= total_supplies:
		all_collected = true
		print("All supplies collected! Return to base!")
