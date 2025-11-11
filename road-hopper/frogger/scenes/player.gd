extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var speed: int = 150


func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	do_animation()
	move_and_slide()

func do_animation() -> void:
	if direction.x < 0:
		$AnimatedSprite2D.play("left")
	elif direction.x > 0:
		$AnimatedSprite2D.play("right")
	elif direction.y < 0:
		$AnimatedSprite2D.play("up")
	elif direction.y > 0:
		$AnimatedSprite2D.play("down")
	else:
		$AnimatedSprite2D.play("idle")
