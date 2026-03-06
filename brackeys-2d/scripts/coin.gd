extends Area2D



func _on_body_entered(_body: Node2D) -> void:
	print("PLAYER +1")
	queue_free()
