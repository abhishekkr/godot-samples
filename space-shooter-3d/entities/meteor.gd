extends Area3D


var direction_x: float = 0.0
var rotate_base_x: float = 0.0
var rotate_base_z: float = 0.0


func _ready() -> void:
	direction_x = randf_range(-0.9, 0.9)
	rotate_base_x = randf_range(-0.9, 1.5)
	rotate_base_z = randf_range(-1.2, 1.25)


func _physics_process(delta: float) -> void:
	position.z += 2 * delta
	position.x += direction_x * delta
	rotate_x(rotate_base_x * delta)
	rotate_z(rotate_base_z * delta)
