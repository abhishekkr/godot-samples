extends CharacterBody2D

@onready var gunman = $Gunman
@onready var bullets = %Bullets
@onready var reload_timer = %ReloadTimer
@onready var crosshair = %Crosshair
@onready var body_upper = %BodyWaistUp
@onready var body_lower = %BodyWaistDown
@onready var body_lower_anim = %BodyWaistDownAnimation
@onready var bullet_tscn = preload("res://scenes/entities/bullet.tscn")

const gun_directions = {
	Vector2i(1,0): 		0,
	Vector2i(1,1): 		1,
	Vector2i(0,1): 		2,
	Vector2i(-1,1): 	3,
	Vector2i(-1,0): 	4,
	Vector2i(-1,-1): 	5,
	Vector2i(0,-1): 	6,
	Vector2i(1,-1): 	7,
}

const SPEED: float = 150.0
const SPEED_WHEN_JUMPING: float = 100.0
const JUMP_Y_OFFSET: float = -150.0
const GRAVITY: float = 250.0
var direction_x: float


func _input(event: InputEvent) -> void:
	if event.is_echo():
		return
	direction_x = Input.get_axis("move_left", "move_right")
	if event.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_Y_OFFSET
	if event.is_action_pressed("shoot") and reload_timer.is_stopped():
		shoot()
		reload_timer.start()


func _physics_process(delta: float) -> void:
	velocity.x = direction_x * speed()
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		body_lower_anim.current_animation = "jump"
	else:
		body_lower_anim.current_animation = "run" if direction_x != 0 else "idle"
	body_lower.flip_h = direction_x < 0
	manage_torso_frame()
	move_and_slide()


func manage_torso_frame() -> void:
	var raw_direction = get_local_mouse_position().normalized()
	var adjusted_direction = Vector2i(round(raw_direction.x), round(raw_direction.y))
	body_upper.frame = gun_directions[adjusted_direction]
	crosshair.position = raw_direction * 25


func shoot() -> void:
	var new_bullet = bullet_tscn.instantiate() as Area2D
	new_bullet.setup(crosshair.transform, get_local_mouse_position())
	bullets.add_child(new_bullet)
	var tween = get_tree().create_tween()
	tween.tween_property(crosshair, "scale", Vector2(0.15, 0.15), 0.2)
	tween.tween_property(crosshair, "scale", Vector2(0.4, 0.4), 0.4)

func speed() -> float:
	if is_on_floor():
		return SPEED
	return SPEED_WHEN_JUMPING
