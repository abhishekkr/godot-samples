extends Area2D

@onready var timer = $Timer

func _on_body_entered(_body: Node2D) -> void:
	GameManager.show_dead_msg()
	Engine.time_scale = 0.5
	timer.wait_time = 2
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
