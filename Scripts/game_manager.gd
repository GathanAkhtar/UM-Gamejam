extends Node

var score = 0
# Make sure this points to your actual ScoreLabel node!
@onready var score_label: Label = $"../UI/ScoreLabel" # Adjust this path if your setup is different

func _ready() -> void:
	# This forces the score to start at 0 every time you boot the game!
	score = 0
	update_ui()

func add_point() -> void:
	score += 1
	print("Current Score: ", score) # This will show up in the Output tab
	update_ui()

func update_ui() -> void:
	if score_label != null:
		score_label.text = "Supplies Found: " + str(score)
