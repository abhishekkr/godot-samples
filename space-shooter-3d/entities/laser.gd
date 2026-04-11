extends Area3D


var SPEED: float = 10.0
var origin_z: float = 0.0
var vanishing_distance: float = 50.0
var vanished: bool = false

func _ready() -> void:
	scale = Vector3(0.05, 0.05, 0.05)
	origin_z = position.z
	var laser_tween = create_tween()
	laser_tween.tween_property(self, "scale", Vector3.ONE, 0.45)


func _physics_process(delta: float) -> void:
	if vanished:
		return
	position.z -= delta * SPEED
	if abs(origin_z - position.z) > vanishing_distance:
		destroy()


func destroy() -> void:
	vanished = true
	queue_free()
