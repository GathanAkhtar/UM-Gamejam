extends Area2D

@onready var pickup_sound = $AudioStreamPlayer2D
@onready var game_manager: Node = %GameManager

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("+1 Supply")
		game_manager.add_point()
		# Hide the item instantly
		visible = false
		set_deferred("monitoring", false)
		if pickup_sound:
			pickup_sound.reparent(get_tree().root)
			pickup_sound.play()
			await pickup_sound.finished
			pickup_sound.queue_free()
		queue_free()
