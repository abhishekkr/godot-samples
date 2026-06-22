extends Node3D
class_name Spear


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body is Player:
		print("PLAYER HURT by ", get_parent_node_3d())
		body.got_hit()
