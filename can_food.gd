extends Area2D

# This grabs that %GameManager node from your Scene Tree
@onready var game_manager: Node = %GameManager

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Tell the GameManager to add a point!
		game_manager.add_point()
		queue_free()
