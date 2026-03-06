extends CharacterBody2D


const SPEED = 125.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sfx = $SFX_JUMP

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_sfx.play()
		animated_sprite.play("roll")
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if not is_on_floor():
		animated_sprite.play("roll")
	elif direction != 0:
		animated_sprite.play("run")
		animated_sprite.flip_h = direction < 0
	else:
		animated_sprite.play("idle")

	move_and_slide()
