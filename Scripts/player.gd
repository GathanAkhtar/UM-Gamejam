extends CharacterBody2D

# --- Variables ---
@onready var death_sound = $DeathSound
@onready var game_manager = %GameManager
var max_sanity = 100.0
var current_sanity = 100.0
var drain_rate = 0.70
var is_outside = true
var is_dead = false
var is_on_ladder = false 
var restore_rate = 3.0  # Adjust this to control how fast sanity restores

@export var sanity_bar: TextureProgressBar
var sanity_prefix = "" 

const SPEED = 150
const JUMP_VELOCITY = -350.0

@onready var anim = $AnimatedSprite2D
var last_direction = "Right"

# --- Sanity Drain Loop ---
func _process(delta: float) -> void:
	if is_dead:
		return

	if is_outside and current_sanity > 0:
		current_sanity -= drain_rate * delta
		current_sanity = max(current_sanity, 0)
	elif not is_outside and current_sanity < max_sanity:
		current_sanity += restore_rate * delta
		current_sanity = min(current_sanity, max_sanity)

	if sanity_bar != null:
		sanity_bar.value = current_sanity

	check_sanity_state()

# --- Sanity Thresholds & Death ---
func check_sanity_state() -> void:
	# 1. Death Logic
	if current_sanity <= 0:
		is_dead = true
		death_sound.play()
		anim.play("Death From Insanity")
		await get_tree().create_timer(5.0).timeout
		get_tree().reload_current_scene()
		return

	# 2. Insanity Tiers (Prefixes)
	if current_sanity <= 20:
		sanity_prefix = "Tier 2 Insanity "
	elif current_sanity <= 50:
		sanity_prefix = "Tier 1 Insanity "
	else:
		sanity_prefix = ""

# --- Movement & Physics ---
func _physics_process(delta: float) -> void:
	if is_dead:
		# Apply gravity while dying
		if not is_on_floor():
			velocity += get_gravity() * delta
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return

	# --- Gravity & Ladder ---
	if is_on_ladder:
		velocity.y = 0 # Disable gravity
		if Input.is_action_pressed("ui_up"):
			velocity.y = -SPEED
		elif Input.is_action_pressed("ui_down"):
			velocity.y = SPEED
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# --- Jumping ---
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or is_on_ladder):
		velocity.y = JUMP_VELOCITY
		# If jumping off a ladder, kick player out of ladder state
		if is_on_ladder:
			is_on_ladder = false

	# --- Horizontal Movement ---
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		last_direction = "Right" if direction > 0 else "Left"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# --- Animation Logic ---
	if is_on_ladder and not is_on_floor():
		if velocity.y != 0:
			anim.play(sanity_prefix + "Climbing")
		else:
			anim.pause() 
	elif is_on_floor():
		if velocity.x > 0:
			anim.play(sanity_prefix + "Run Right")
		elif velocity.x < 0:
			anim.play(sanity_prefix + "Run Left")
		else:
			anim.play(sanity_prefix + "Idle " + last_direction)
	else:
		# Basic air logic to prevent stuck animations
		if velocity.x > 0: last_direction = "Right"
		elif velocity.x < 0: last_direction = "Left"

	move_and_slide()

# --- Signal Connections ---
# Make sure your Climbzone signals are connected to these!
func _on_climbzone_body_entered(body: Node2D) -> void:
	if body == self:
		is_on_ladder = true

func _on_climbzone_body_exited(body: Node2D) -> void:
	if body == self:
		is_on_ladder = false
		
		
func _on_bunker_zone_body_entered(body: Node2D) -> void:
	if body == self:
		is_outside = false
		# Check win condition
		if game_manager.all_collected:
			print("You win!")
			await get_tree().create_timer(1.5).timeout
			get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")

func _on_bunker_zone_body_exited(body: Node2D) -> void:
	if body == self:
		is_outside = true
