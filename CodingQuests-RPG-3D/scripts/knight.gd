extends CharacterBody3D


@onready var camroot_h = get_node("CamRoot/H")
@onready var player_mesh = get_node("Knight")

@export var gravity: float = 9.8
@export var jump_force: float = 9
@export var walk_speed: float = 3
@export var run_speed: float = 10

# Animation Node Names
var idle_node_name: String = "Idle"
var walk_node_name: String = "Walk"
var run_node_name: String = "Run"
var jump_node_name: String = "Jump"
var attack_node_name: String = "Attack"
var death_node_name: String = "Death"

# State Machine Conditions
var is_attacking: bool
var is_walking: bool
var is_running: bool
var is_dying: bool
var just_hit: bool

# Physics Values
var direction: Vector3
var velocity_h: Vector3
var velocity_v: Vector3
var aim_turn: float
var movement: Vector3
var movement_speed: float
var acceleration: int
var angular_acceleration: int
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.015
	if event.is_action_pressed("aim"):
		direction = camroot_h.global_transform.basis.z
		
func _physics_process(delta: float) -> void:
	var on_floor = is_on_floor()
	if is_dying:
		return
	if !on_floor:
		velocity_v += Vector3.DOWN * gravity * 2 * delta
	else:
		velocity_v += Vector3.DOWN * gravity / 10
	if Input.is_action_just_pressed("jump") and (!is_attacking) and on_floor:
		velocity_v = Vector3.UP * jump_force
	
	angular_acceleration = 10
	movement_speed = 0
	acceleration = 15
	var rotation_h = camroot_h.global_transform.basis.get_euler().y
	if (Input.is_action_pressed("forward") || 
		Input.is_action_pressed("backward") ||
		Input.is_action_pressed("left") ||
		Input.is_action_pressed("right")):
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"),
							0,
							Input.get_action_strength("forward") - Input.get_action_strength("backward"),
							)
		direction = direction.rotated(Vector3.UP, rotation_h).normalized()
		if (Input.is_action_pressed("forward") and is_walking):
			is_running = true
			is_walking = false
			movement_speed = run_speed
		else:
			is_walking = true
			is_running = false  
			movement_speed = walk_speed
	else:
		is_walking = false
		is_running = false
		
	if Input.is_action_pressed("aim"):
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, 
											camroot_h.rotation.y, 
											delta*angular_acceleration)
	else:
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, 
											atan2(direction.x, direction.x) - rotation.y, 
											delta*angular_acceleration)
	if is_attacking:
		velocity_h = velocity_h.lerp(direction.normalized()*0.1, acceleration)
	else:
		velocity_h = velocity_h.lerp(direction.normalized()*movement_speed, acceleration)
	velocity.z = velocity_h.z + velocity_v.z
	velocity.x = velocity_h.x + velocity_v.x
	velocity.y = velocity_v.y
	move_and_slide()


## CTRL+K to toggle comments ... below is basic movement code that used to be default
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#
#
#func _physics_process(delta: float) -> void:
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	#
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	#
	#var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_direction.x, 0, input_direction.y))
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
	#move_and_slide()
