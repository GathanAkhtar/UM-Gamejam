extends CharacterBody2D

# --- Sanity Variables ---
var max_sanity = 100.0
var current_sanity = 100.0
var drain_rate = 0.83 # How much sanity is lost per second
var is_outside = true # We will use this to stop the drain when inside

@export var sanity_bar: TextureProgressBar
var sanity_prefix = "" # This will hold "Tier 1 Insanity ", etc.
var is_dead = false    # We use this to stop the player from moving when they die

const SPEED = 150
const JUMP_VELOCITY = -350.0

@onready var anim = $AnimatedSprite2D

# We use this to remember which way we were looking when we stop
var last_direction = "Right"


# --- Sanity Drain Loop ---
func _process(delta: float) -> void:
	# If we are dead, stop draining sanity and ignore this code
	if is_dead:
		return 

	if is_outside and current_sanity > 0:
		current_sanity -= drain_rate * delta
		
		# Update the UI bar safely (checks if you actually dragged the bar into the slot)
		if sanity_bar != null:
			sanity_bar.value = current_sanity
			
		check_sanity_state()


# --- Sanity Thresholds ---
func check_sanity_state() -> void:
	# 1. Death State
	if current_sanity <= 0:
		current_sanity = 0
		is_dead = true
		anim.play("Death From Insanity")
		
		# --- NEW RESTART CODE ---
		# Wait 1.5 seconds so the death animation actually plays
		await get_tree().create_timer(1.5).timeout
		
		# Restart the current level
		get_tree().reload_current_scene()
		# ------------------------
		
		return # Stops reading the rest of the function

	# 2. Tier 2 Insanity (20% or less)
	elif current_sanity <= 20:
		sanity_prefix = "Tier 2 Insanity "

	# 3. Tier 1 Insanity (50% or less)
	elif current_sanity <= 50:
		sanity_prefix = "Tier 1 Insanity "

	# 4. Normal State (Above 50%)
	else:
		sanity_prefix = ""


# --- Movement & Physics ---
func _physics_process(delta: float) -> void:
	# Immediately stop all movement and input if the player is dead
	if is_dead:
		# Apply gravity so a dying player still falls to the floor
		if not is_on_floor():
			velocity += get_gravity() * delta
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return

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

	# --- Animation Logic ---
	if is_on_floor():
		if velocity.x > 0:
			# Glues the prefix to the action: e.g., "Tier 1 Insanity Run Right"
			anim.play(sanity_prefix + "Run Right")
		elif velocity.x < 0:
			anim.play(sanity_prefix + "Run Left")
		else:
			# If stopped, play the Idle animation for the last direction moved
			anim.play(sanity_prefix + "Idle " + last_direction)
	else:
		# Optional: Add a jump animation here if you have one!
		pass

	move_and_slide()
