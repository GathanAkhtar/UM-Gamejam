extends CharacterBody2D

const SPEED = 150
const JUMP_VELOCITY = -350.0

@onready var anim = $AnimatedSprite2D

# We use this to remember which way we were looking when we stop
var last_direction = "Right"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, or 1
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		# Update our tracker whenever there is movement input
		if direction > 0:
			last_direction = "Right"
		else:
			last_direction = "Left"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animation Logic
	if is_on_floor():
		if velocity.x > 0:
			anim.play("Run Right")
		elif velocity.x < 0:
			anim.play("Run Left")
		else:
			# If stopped, play the Idle animation for the last direction moved
			# This assumes you have "Idle Right" and "Idle Left" animations
			anim.play("Idle " + last_direction)
	else:
		# Optional: Add a jump animation here if you have one!
		pass

	move_and_slide()
