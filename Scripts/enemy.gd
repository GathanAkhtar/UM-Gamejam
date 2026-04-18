extends Node2D

@export var speed: float = 60.0
@export var patrol_distance: float = 80.0
@export var start_direction: int = -1

var direction: int
var start_pos_x: float

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $Killzone
@onready var timer: Timer = $Killzone/Timer  # Reference the existing Timer

func _ready() -> void:
	direction = start_direction
	start_pos_x = position.x

func _process(delta: float) -> void:
	position.x += direction * speed * delta

	if direction == -1 and position.x <= start_pos_x - patrol_distance:
		direction = 1
	elif direction == 1 and position.x >= start_pos_x + patrol_distance:
		direction = -1

	if direction == 1:
		anim.play("Enemy Move Right")
	else:
		anim.play("Enemy Move Left")

func _on_killzone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("You died")
		Engine.time_scale = 0.5
		body.is_dead = true
		timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
