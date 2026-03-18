extends CharacterBody3D

#@export var TO_FOLLOW = null
@export var SPEED: float = 3.5

@onready var RedirectTimer = $Timer
@onready var NAV_AGENT = $NavigationAgent3D
var targetLocation: Vector3

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	resetTarget()
	RedirectTimer.start()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 10
		move_and_slide()
	
	if position.distance_to(targetLocation) > 0.5:
		look_at(targetLocation)
		rotation.x = 0
		rotation.z = 0
		var direction = global_position.direction_to(targetLocation)
		velocity = direction * SPEED
		move_and_slide()
	else:
		resetTarget()


func resetTarget() -> void:
	rng.randomize()
	targetLocation = Vector3(randf_range(-45, 45), 0, randf_range(-45, 45))
	targetLocation.y = position.y
	NAV_AGENT.set_target_position(targetLocation)


func _on_timer_timeout() -> void:
	resetTarget()


func _on_area_3d_area_entered(area: Area3D) -> void:
	RedirectTimer.stop()
	print("PLAYER SEEN")
	targetLocation = area.global_transform.origin
	targetLocation.y = position.y
	NAV_AGENT.set_target_position(targetLocation)


func _on_area_3d_area_exited(_area: Area3D) -> void:
	resetTarget()
	RedirectTimer.start()
