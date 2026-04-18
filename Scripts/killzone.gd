extends Area2D

@onready var timer: Timer = $Timer  # Uses "Timer" not "Timer2"
@onready var anim = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("You died to enemy")
		Engine.time_scale = 0.2
		body.get_node("AnimatedSprite2D").play("Death From Insanity")
		body.is_dead = true
		body.get_node("DeathSound").play()
			
		timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
