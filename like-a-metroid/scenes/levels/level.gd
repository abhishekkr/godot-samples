extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_tree().get_nodes_in_group("Lights"):
		var light_tween = create_tween()
		light_tween.set_loops()
		light_tween.tween_property(node, "energy", randf()+1, randf()+0.1)
		light_tween.tween_property(node, "energy", randf(), 0.1)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
