extends Area2D

func _on_body_entered(body):
	if body.has_method("_physics_process"):
		body.can_climb = true

func _on_body_exited(body):
	if body.has_method("_physics_process"):
		body.can_climb = false
		body.on_ladder = false
