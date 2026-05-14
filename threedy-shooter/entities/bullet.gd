extends Node3D


@export var speed: float = 15.0
@export var disappear_time: float = 0.75


func _ready() -> void:
	get_tree().create_tween().tween_callback(queue_free).set_delay(disappear_time)


func _process(delta: float) -> void:
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * speed * delta)
