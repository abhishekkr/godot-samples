extends CharacterBody2D

@onready var player_body = %HappyBoo

const SPEED = 300.0

func _ready() -> void:
	player_body.play_idle_animation()


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if velocity.length() > 0.0:
		player_body.play_walk_animation()
		move_and_slide()
	else:
		player_body.play_idle_animation()
