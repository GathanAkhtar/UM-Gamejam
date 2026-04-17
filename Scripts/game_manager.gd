extends Node

var score = 0
@onready var score_label: Label = $UI/ScoreLabel
 

func add_point():
	score += 1
	score_label.text = "Supplies Found: " + str(score)
 
