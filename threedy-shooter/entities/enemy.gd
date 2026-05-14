extends CharacterBody3D
class_name Enemy

@onready var sound_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var jump_timer: Timer = $JumpTimer

const SPEED = 3.5
const JUMP_VELOCITY = 6.5


func _ready() -> void:
	if jump_timer.is_stopped():
		jump_timer.start()
		jump_timer.wait_time = randf_range(7.5, 15.5)



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func _on_jump_timer_timeout() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	jump_timer.wait_time = randf_range(7.5, 15.5)


func got_hit() -> void:
	sound_player.play()
	print("ENEMY IS HIT.")
