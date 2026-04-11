extends Node3D


func _ready() -> void:
	$MeshInstance3D.rotate_z(-10.0)
	$MeshInstance3D.mesh.material.albedo_color = Color.DARK_ORANGE


func _process(delta: float) -> void:
	$MeshInstance3D.rotate_z(-2.0 * delta)
	$MeshInstance3D.rotate_y(1.0 * delta)
	var mesh_tween = create_tween()
	mesh_tween.set_loops(0)
	mesh_tween.tween_property($MeshInstance3D.mesh.material, "albedo_color", Color(1,0,0,1), 0.3)
	mesh_tween.tween_property($MeshInstance3D.mesh.material, "albedo_color", Color(0.5,0.7,0.2,1), 0.1)
