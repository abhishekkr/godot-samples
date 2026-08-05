extends CharacterBody3D

@onready var cam_h_pivot: Node3D = $CamHPivot
@onready var cam_v_pivot: Node3D = $CamHPivot/CamVPivot
@onready var cam_spring_arm_3d: SpringArm3D = $CamSpringArm3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var mouse_sensitivity: float = 0.00075
@export var vertical_min_boundary: float = -60
@export var vertical_max_boundary: float = 15
@export var decay: float = 25.0 	# larger the decay, longer time to move

var looking_direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		move_looking_direction(event)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := get_movement_direction()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	move_camera(delta)


func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var input_vector := Vector3(input_dir.x, 0, input_dir.y).normalized()
	return cam_v_pivot.global_transform.basis * input_vector


func move_looking_direction(event: InputEvent) -> void:
	var dots_moved: Vector2 = event.screen_relative
	looking_direction += (-dots_moved) * mouse_sensitivity


func move_camera(delta: float) -> void:
	if looking_direction == Vector2.ZERO:
		return
	cam_h_pivot.rotate_y(looking_direction.x*2.5)
	cam_v_pivot.rotate_x(looking_direction.y)
	cam_v_pivot.rotation.x = clampf(
		cam_v_pivot.rotation.x,
		deg_to_rad(vertical_min_boundary),
		deg_to_rad(vertical_max_boundary),
		)
	var wt: float = 1.0 - exp(-decay * delta)
	cam_spring_arm_3d.global_transform = cam_spring_arm_3d.global_transform.interpolate_with(
		cam_v_pivot.global_transform,
		wt,
		)
	looking_direction = Vector2.ZERO
