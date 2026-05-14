extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 5.5
var direction: Vector3


func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("do_jump"):
		if not event.is_echo() and is_on_floor():
			velocity.y = JUMP_VELOCITY
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
