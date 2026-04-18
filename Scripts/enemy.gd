extends Node2D

@export var speed: float = 60.0
@export var patrol_distance: float = 80.0
@export var start_direction: int = -1

var direction: int
var start_pos_x: float

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

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
