extends Area2D

@onready var timer = $Timer

func _on_body_entered(_body: Node2D) -> void:
	print("You Died.")
	Engine.time_scale = 0.5
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
