extends CharacterBody3D

const ACCELERATION = 3.5
const SPEED = 5.0
const JUMP_SPEED = 4.0
const MOUSE_SENSITIVITY = 0.05

var FACE_CAMERA
var FACE_CAMERA_PIVOT


func _ready() -> void:
	FACE_CAMERA = $CameraPivot/Camera3D
	FACE_CAMERA_PIVOT = $CameraPivot
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:	
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("move_jump"):
			velocity.y = JUMP_SPEED
	else:
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	## var direction := input_movement_vector.rotated(-global_rotation.y)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = lerp(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	input_dir = input_dir.normalized()
	var cam_xform = FACE_CAMERA.get_global_transform()
	direction += -cam_xform.basis.z * input_dir.y
	direction += cam_xform.basis.x * input_dir.x
			
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		FACE_CAMERA_PIVOT.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = FACE_CAMERA_PIVOT.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		FACE_CAMERA_PIVOT.rotation_degrees = camera_rot
