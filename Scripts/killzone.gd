extends Area2D

@onready var timer_2: Timer = $Timer2

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("You died")
		Engine.time_scale = 0.5 # Slow motion!
		body.is_dead = true # Freeze the player
		timer_2.start()

func _on_timer_2_timeout() -> void:
	Engine.time_scale = 1.0 # Set time back to normal
	get_tree().reload_current_scene() # Restart the level
