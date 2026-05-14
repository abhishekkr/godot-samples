extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var player: Player = $Player

const ray_length: float = 2000

var ray_origin: Vector3
var ray_target: Vector3


func _process(_delta: float) -> void:
	look_at_mouse()


func look_at_mouse() -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	ray_origin = camera.project_ray_origin(mouse_pos)
	ray_target = ray_origin + camera.project_ray_normal(mouse_pos) * ray_length
	var space_state = get_world_3d().direct_space_state
	var ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_target)
	var intersection = space_state.intersect_ray(ray_query)
	if not intersection.is_empty():
		var intersect_at_pos = intersection.get('position')
		intersect_at_pos.y = player.global_position.y
		var up_axis := Vector3(0, player.global_position.y, 0)
		player.look_at(intersect_at_pos, up_axis, true)
